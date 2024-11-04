//
//  SettingsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift
import Swinject
import MusicBox

class DownloadsViewController: UIViewController {
  private let noDownloadsFoundView = NoDownloadsFoundView()
  private lazy var coreDataStack = CoreDataStack()
  private let hideEmptyDownloadsView = BehaviorRelay<Bool>(value: true)
  private let downloadTableView = DownloadTableView()
  private let downloadViewModel = Container.sharedContainer.resolve(DownloadViewModel.self)!
  private let disposeBag = DisposeBag()
  
  private let progressButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .preferredCustomFont(forTextStyle: .callout, weight: .bold)
    button.setTitleColor(.accent, for: .normal)
    button.backgroundColor = .accent.withAlphaComponent(0.1)
    button.clipsToBounds = true
    button.layer.cornerRadius = 8
    return button
  }()
  
  private lazy var fetchedResultController: NSFetchedResultsController<MusicItemModel> = {
    let fetchRequest = MusicItemModel.fetchRequest()
    let sort = NSSortDescriptor(key: #keyPath(MusicItemModel.title), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    fetchRequest.predicate = NSPredicate(format: "%K != NULL", #keyPath(MusicItemModel.localStorageURL))
    
    return NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: "com.MusicApp.DownloadTableView"
    )
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Downloads"
    
    view.addSubview(downloadTableView)
    view.addSubview(noDownloadsFoundView)
    view.addSubview(progressButton)
    
    hideEmptyDownloadsView
      .bind(to: noDownloadsFoundView.rx.isHidden)
      .disposed(by: disposeBag)
    
//    hideEmptyDownloadsView
//      .bind(to: progressButton.rx.isEnabled)
//      .disposed(by: disposeBag)
    
    downloadTableView.delegate = self
    downloadTableView.dataSource = self
    fetchedResultController.delegate = self
    
    downloadViewModel
      .inProgressDownlods
      .observe(on: MainScheduler.instance)
      .bind { [weak self] musicItems in
        self?.progressButton.setTitle("\(musicItems.count) Download(s) in progress", for: .normal)
      }
      .disposed(by: disposeBag)
    
    NSLayoutConstraint.activate([
      noDownloadsFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDownloadsFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDownloadsFoundView.widthAnchor.constraint(equalToConstant: 250),
      
      progressButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      progressButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      progressButton.heightAnchor.constraint(equalToConstant: 50),
      progressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      downloadTableView.topAnchor.constraint(equalTo: progressButton.bottomAnchor, constant: 10),
      downloadTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      downloadTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      downloadTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    do {
      try fetchedResultController.performFetch()
      guard let
              downloadsCount = fetchedResultController.sections?.first?.numberOfObjects,
              downloadsCount > 0 else {
        hideEmptyDownloadsView.accept(false)
        return
      }
    } catch {
      print("Error NSFetchResultsController \(error.localizedDescription)")
    }
  }
}

extension DownloadsViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    self.downloadViewModel.removeDownloadedItem(
      musicItemModel: fetchedResultController.object(at: indexPath)
    )
  }
}

extension DownloadsViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let sectionInfo =
            fetchedResultController.sections?[section] else {
      return 0
    }
    return sectionInfo.numberOfObjects
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: DownloadTableView.reusableIdentifier,
      for: indexPath
    ) as? DownloadTableViewCell else {
      return UITableViewCell()
    }
    let musicItemModel = fetchedResultController.object(at: indexPath)
    cell.musicItemModel = musicItemModel
    cell.bindWithViewModel(viewModel: self.downloadViewModel)
      
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let musicItemModel = fetchedResultController.object(at: indexPath)
    let musicItem = MusicItem.init(
      title: musicItemModel.title ?? "-",
      publisherTitle: musicItemModel.publisherTitle ?? "-",
      runningDurationInSeconds: Int(musicItemModel.runningDurationInSeconds),
      musicId: musicItemModel.musicId ?? "-",
      smallestThumbnail: musicItemModel.smallestThumbnail,
      largestThumbnail: musicItemModel.largestThumbnail
    )
    self.downloadViewModel.playingViewModel.playMusicItem(musicItem: musicItem)
  }
}

extension DownloadsViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    downloadTableView.beginUpdates()
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
      downloadTableView.insertRows(at: [newIndexPath!], with: .automatic)
      hideEmptyDownloadsView.accept(true)
      let cell = downloadTableView.cellForRow(at: newIndexPath!) as? PlaylistTableViewCell
      cell?.musicPlaylistModel = controller.object(at: newIndexPath!) as? MusicPlaylistModel
    case .delete:
      downloadTableView.deleteRows(at: [indexPath!], with: .automatic)
      guard let count = controller.fetchedObjects?.count, count > 0 else {
        hideEmptyDownloadsView.accept(false)
        return
      }
    case .update:
      let cell = downloadTableView.cellForRow(at: indexPath!) as! PlaylistTableViewCell
      cell.musicPlaylistModel = controller.object(at: indexPath!) as? MusicPlaylistModel
    case .move:
      downloadTableView.deleteRows(at: [indexPath!], with: .automatic)
      downloadTableView.insertRows(at: [newIndexPath!], with: .automatic)
    @unknown default:
      print("Unexpected NSFetchedResultChangeType: \(type)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    downloadTableView.endUpdates()
  }
}
