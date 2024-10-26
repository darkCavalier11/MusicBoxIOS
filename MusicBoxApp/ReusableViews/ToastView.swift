//
//  ToastView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 26/10/24.
//


import UIKit

final class ToastView: UIView {
  private lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .callout)
    label.numberOfLines = 0
    return label
  }()
  
  var text: String? {
    didSet {
      label.text = text
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    self.backgroundColor = .darkText
    self.layer.shadowColor = UIColor.tintColor.cgColor
    label.textColor = .lightText
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
      label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIViewController {
  func showToast(text: String) {
    let toastView = ToastView()
    toastView.text = text
    toastView.translatesAutoresizingMaskIntoConstraints = false
    toastView.transform = CGAffineTransform(translationX: 0, y: 120)
    
    view.addSubview(toastView)
    
    NSLayoutConstraint.activate([
      toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    UIView.animate(withDuration: 0.8) {
      toastView.transform = .identity
    }
    
    UIView.animate(withDuration: 0.4, delay: 2.3) {
      toastView.transform = CGAffineTransform(translationX: 0, y: 120)
    } completion: { _ in
      toastView.removeFromSuperview()
    }
  }
}
