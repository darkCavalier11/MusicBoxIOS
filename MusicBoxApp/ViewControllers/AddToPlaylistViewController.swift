//
//  AddToPlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 25/10/24.
//

import UIKit

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Add to playlist"
    textFieldcontainerView.addSubview(newPlaylistTextField)
    view.addSubview(textFieldcontainerView)
    view.addSubview(createAndAddPlaylistButton)
    view.addSubview(addToPlaylistLabel)
    
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
    ])
  }
}
