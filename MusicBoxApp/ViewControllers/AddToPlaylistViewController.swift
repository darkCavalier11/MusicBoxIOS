//
//  AddToPlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 25/10/24.
//

import UIKit
import CoreData

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
  
  private let playlistTableView: UITableView = PlaylistTableView()
  private lazy var coreDataStack = CoreDataStack()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Add to playlist"
    textFieldcontainerView.addSubview(newPlaylistTextField)
    view.addSubview(textFieldcontainerView)
    view.addSubview(createAndAddPlaylistButton)
    view.addSubview(addToPlaylistLabel)
    view.addSubview(playlistTableView)
    view.addSubview(noExistingPlaylistLabel)
    
    do {
      try fetchedResultController.performFetch()
      if fetchedResultController.sections?.isEmpty == true {
        noExistingPlaylistLabel.isHidden = false
      }
    } catch {
      
    }
    
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
  }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableView.reusableIdentifier, for: indexPath)
    return cell
  }
}

extension AddToPlaylistViewController: UITableViewDelegate {
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
