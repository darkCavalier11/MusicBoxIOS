//
//  PlaylistTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//

import UIKit

class PlaylistTableView: UITableView {
  static let reusableIdentifier: String = "PlaylistTableViewCell"
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    register(PlaylistTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.rowHeight = 120
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PlaylistTableViewCell: UITableViewCell {
  private let playlistImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "OnboardingLogo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.layer.shadowColor = CGColor.init(red: 1.0, green: 0, blue: 0, alpha: 1)
    imageView.layer.shadowOpacity = 0.5
    return imageView
  }()
  
  private let playlistImageView1: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "OnboardingLogo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.transform = CGAffineTransform(translationX: 20, y: 0).rotated(by: Double.pi / 15)
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private let playlistImageView2: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "OnboardingLogo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.transform = CGAffineTransform(translationX: -20, y: 0).rotated(by: -Double.pi / 15)
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private let playlistTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Your playlist"
    label.numberOfLines = 2
    label.font = .preferredCustomFont(forTextStyle: .headline)
    return label
  }()
  
  private let durationTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Total Duration: 01:03:45"
    label.font = .preferredCustomFont(forTextStyle: .caption1, weight: .bold)
    return label
  }()
  
  private let artistDesc: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Eminem, Ariana Grande, Drake and others"
    label.font = .preferredCustomFont(forTextStyle: .caption1)
    label.numberOfLines = 2
    label.textColor = .secondaryLabel
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let containerView = UIView()
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.addArrangedSubview(playlistTitle)
    stackView.addArrangedSubview(durationTitle)
    stackView.addArrangedSubview(artistDesc)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(containerView)
    
    containerView.addSubview(playlistImageView1)
    containerView.addSubview(playlistImageView2)
    containerView.addSubview(playlistImageView)
    containerView.addSubview(stackView)
    
    
    NSLayoutConstraint.activate([
      playlistImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      playlistImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      playlistImageView.widthAnchor.constraint(equalToConstant: 75),
      playlistImageView.heightAnchor.constraint(equalToConstant: 75),
      
      playlistImageView1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      playlistImageView1.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      playlistImageView1.widthAnchor.constraint(equalToConstant: 75),
      playlistImageView1.heightAnchor.constraint(equalToConstant: 75),
      
      playlistImageView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      playlistImageView2.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      playlistImageView2.widthAnchor.constraint(equalToConstant: 75),
      playlistImageView2.heightAnchor.constraint(equalToConstant: 75),
      
      containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
      containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      stackView.leadingAnchor.constraint(equalTo: playlistImageView.trailingAnchor, constant: 50),
      stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
