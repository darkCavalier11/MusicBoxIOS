//
//  HomeScreenLoadingView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 12/11/24.
//

import UIKit

class HomeScreenLoadingView: UIView {
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.style = .medium
    activityIndicator.startAnimating()
    return activityIndicator
  }()
  
  private let titleLabel: UILabel = {
    let titleLabel = UILabel()
    let index = Int.random(in: 0..<musicFacts.count)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = musicFacts[index]
    titleLabel.font = .preferredCustomFont(forTextStyle: .callout)
    titleLabel.textColor = .systemGray
    titleLabel.numberOfLines = -1
    return titleLabel
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.alignment = .center
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(stackView)
    stackView.addArrangedSubview(activityIndicator)
    stackView.addArrangedSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.widthAnchor.constraint(equalToConstant: 250)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
