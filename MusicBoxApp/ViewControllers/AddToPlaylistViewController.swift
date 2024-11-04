//
//  AddToPlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 25/10/24.
//

import UIKit
import CoreData
import MusicBox
import RxSwift
import RxCocoa


class AddToPlaylistViewController: UIViewController {
  private let newPlaylistTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "New Playlist Name"
    textField.borderStyle = .none
    return textField
  }()
  
  private lazy var textFieldcontainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .quaternaryLabel
    view.layer.cornerRadius = 6
    return view
  }()
  
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
  
  private let createAndAddPlaylistButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Create and Add to Playlist", for: .normal)
    button.addTarget(self, action: #selector(createAndAddPlaylistButtonTapped), for: .touchUpInside)
    button.backgroundColor = .accent
    button.layer.cornerRadius = 6
    return button
  }()
  
  private let addToPlaylistLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Add to existing playlist(s)"
    label.font = .preferredCustomFont(forTextStyle: .title3)
    return label
  }()
  
  private let noExistingPlaylistLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "No existing playlist(s)"
    label.textColor = .secondaryLabel
    label.font = .preferredFont(forTextStyle: .caption1)
    return label
  }()
  
  @objc func createAndAddPlaylistButtonTapped() {
    guard let title = newPlaylistTextField.text else { return }
    musicPlaylistService.addNewPlaylist(
      title: title,
      musicItems: musicItem != nil ? [musicItem!] : []
    )
    newPlaylistTextField.text = nil
  }
  
  private let playlistTableView: UITableView = PlaylistTableView()
  private lazy var coreDataStack = CoreDataStack()
  private lazy var musicPlaylistService = MusicPlaylistServices(
    coreDataStack: coreDataStack,
    context: coreDataStack.managedObjectContext
  )
  private let hideEmptyPlaylistView = BehaviorRelay<Bool>(value: true)
  private let disposeBag = DisposeBag()
  
  var musicItem: MusicItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Add to playlist"
    textFieldcontainerView.addSubview(newPlaylistTextField)
    view.backgroundColor = .systemBackground
    view.addSubview(textFieldcontainerView)
    view.addSubview(createAndAddPlaylistButton)
    view.addSubview(addToPlaylistLabel)
    view.addSubview(playlistTableView)
    view.addSubview(noExistingPlaylistLabel)
    
    playlistTableView.dataSource = self
    playlistTableView.delegate = self
    fetchedResultController.delegate = self

    
    NSLayoutConstraint.activate([
      textFieldcontainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
      textFieldcontainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      textFieldcontainerView.heightAnchor.constraint(equalToConstant: 40),
      textFieldcontainerView.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      newPlaylistTextField.widthAnchor.constraint(equalTo: textFieldcontainerView.widthAnchor, multiplier: 0.95),
      newPlaylistTextField.centerYAnchor.constraint(equalTo: textFieldcontainerView.centerYAnchor),
      newPlaylistTextField.centerXAnchor.constraint(equalTo: textFieldcontainerView.centerXAnchor),
      
      createAndAddPlaylistButton.topAnchor.constraint(equalTo: textFieldcontainerView.bottomAnchor, constant: 10),
      createAndAddPlaylistButton.widthAnchor.constraint(equalTo: textFieldcontainerView.widthAnchor),
      createAndAddPlaylistButton.heightAnchor.constraint(equalToConstant: 40),
      createAndAddPlaylistButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      addToPlaylistLabel.topAnchor.constraint(equalTo: createAndAddPlaylistButton.bottomAnchor, constant: 10),
      addToPlaylistLabel.leadingAnchor.constraint(equalTo: textFieldcontainerView.leadingAnchor),
      
      playlistTableView.topAnchor.constraint(equalTo: addToPlaylistLabel.bottomAnchor),
      playlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      playlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      noExistingPlaylistLabel.centerXAnchor.constraint(equalTo: playlistTableView.centerXAnchor),
      noExistingPlaylistLabel.centerYAnchor.constraint(equalTo: playlistTableView.centerYAnchor),
    ])
    
    hideEmptyPlaylistView
      .bind(to: noExistingPlaylistLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    do {
      try fetchedResultController.performFetch()
      guard let playlistCount = fetchedResultController.sections?.first?.numberOfObjects, playlistCount > 0 else {
        hideEmptyPlaylistView.accept(false)
        return
      }
    } catch {
      print("Error NSFetchResultsController \(error.localizedDescription)")
    }
  }
}

extension AddToPlaylistViewController: UITableViewDelegate {
  
}

extension AddToPlaylistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionInfo =
            fetchedResultController.sections?[section] else {
      return 0
    }
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableView.reusableIdentifier, for: indexPath) as? PlaylistTableViewCell else {
      return UITableViewCell()
    }
    cell.musicPlaylistModel = fetchedResultController.object(at: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let musicItem = musicItem else { return }
    let model = fetchedResultController.object(at: indexPath)
    let addedToPlaylist = self.musicPlaylistService.addToPlaylist(model: model, musicItem: musicItem)
    if addedToPlaylist {
      showToast(text: "Added \(musicItem.title) to \"\(model.title ?? "")\"")
    } else {
      showToast(text: "\(musicItem.title) already in \"\(model.title ?? "")\"")
    }
  }
}

extension AddToPlaylistViewController: NSFetchedResultsControllerDelegate {
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
      hideEmptyPlaylistView.accept(true)
      let cell = playlistTableView.cellForRow(at: newIndexPath!) as? PlaylistTableViewCell
      cell?.musicPlaylistModel = controller.object(at: newIndexPath!) as? MusicPlaylistModel
    case .delete:
      playlistTableView.deleteRows(at: [indexPath!], with: .automatic)
      guard let count = controller.fetchedObjects?.count, count > 0 else {
        hideEmptyPlaylistView.accept(false)
        return
      }
    case .update:
      let cell = playlistTableView.cellForRow(at: indexPath!) as! PlaylistTableViewCell
      cell.musicPlaylistModel = controller.object(at: indexPath!) as? MusicPlaylistModel
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
