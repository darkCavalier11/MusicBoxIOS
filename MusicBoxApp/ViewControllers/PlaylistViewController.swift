//
//  PlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift

class PlaylistViewController: UIViewController {
  private lazy var coreDataStack = CoreDataStack()
  private lazy var musicPlaylistService = MusicPlaylistServices(
    coreDataStack: coreDataStack,
    context: coreDataStack.managedObjectContext
  )
  
  private let hideEmptyPlaylistView = BehaviorRelay<Bool>(value: true)
  private let disposeBag = DisposeBag()
  
  private lazy var fetchedResultController: NSFetchedResultsController<MusicPlaylistModel> = {
    let fetchRequest = MusicPlaylistModel.fetchRequest()
    let sort = NSSortDescriptor(key: #keyPath(MusicPlaylistModel.title), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    return NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: "com.MusicApp.PlaylistTableView"
    )
  }()
  
  private let noPlaylistFoundView = NoPlaylistFoundView()
  private let playlistTableView = PlaylistTableView()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Your playlists"
    
    playlistTableView.delegate = self
    playlistTableView.dataSource = self
    fetchedResultController.delegate = self
    
    
    view.addSubview(playlistTableView)
    view.addSubview(noPlaylistFoundView)
    
    hideEmptyPlaylistView
      .bind(to: noPlaylistFoundView.rx.isHidden)
      .disposed(by: disposeBag)
    
    setupPlaylistTableViewConstraints()
    setupNoPlaylistFoundViewConstraints()
    
    do {
      try fetchedResultController.performFetch()
      guard let playlistCount = fetchedResultController.sections?.first?.numberOfObjects, playlistCount > 0 else {
        hideEmptyPlaylistView.accept(false)
        return
      }
    } catch {
      print("Unable to init fetchResultController(:) \(error.localizedDescription)")
    }
  }
  
  func setupPlaylistTableViewConstraints() {
    NSLayoutConstraint.activate([
      playlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      playlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      playlistTableView.topAnchor.constraint(equalTo: view.topAnchor)
    ])
  }
  
  func setupNoPlaylistFoundViewConstraints() {
    NSLayoutConstraint.activate([
      noPlaylistFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noPlaylistFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noPlaylistFoundView.widthAnchor.constraint(equalToConstant: 250),
    ])
  }
}

extension PlaylistViewController: UITableViewDelegate {
  
}

extension PlaylistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionInfo =
            fetchedResultController.sections?[section] else {
      return 0
    }
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableView.reusableIdentifier, for: indexPath)
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    let musicModel = self.fetchedResultController.object(at: indexPath)
    self.musicPlaylistService.removePlaylist(model: musicModel)
  }
}

extension PlaylistViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    playlistTableView.beginUpdates()
  }
  
  func controller(
    _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
    switch type {
    case .insert:
      playlistTableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      playlistTableView.deleteRows(at: [indexPath!], with: .automatic)
      guard let count = controller.fetchedObjects?.count, count > 0 else {
        hideEmptyPlaylistView.accept(false)
        return
      }
    case .update:
      let cell = playlistTableView.cellForRow(at: indexPath!) as! PlaylistTableViewCell
    case .move:
      playlistTableView.deleteRows(at: [indexPath!], with: .automatic)
      playlistTableView.insertRows(at: [newIndexPath!], with: .automatic)
    @unknown default:
      print("Unexpected NSFetchedResultChangeType: \(type)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    playlistTableView.endUpdates()
  }
}
