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
  
  private lazy var backView1: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .darkText
    view.layer.cornerRadius = 24
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(backView1)
    addSubview(label)
    backView1.backgroundColor = .label
    self.layer.cornerRadius = 72
    label.textColor = .systemBackground
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
      label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
      
      backView1.widthAnchor.constraint(equalTo: self.widthAnchor),
      backView1.heightAnchor.constraint(equalTo: self.heightAnchor),
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
    toastView.transform = CGAffineTransform(translationX: 0, y: -240)
    
    view.addSubview(toastView)
    
    NSLayoutConstraint.activate([
      toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      toastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
    ])
    
    UIView.animate(withDuration: 0.8) {
      toastView.transform = .identity
    }
    
    UIView.animate(withDuration: 0.4, delay: 2.3) {
      toastView.transform = CGAffineTransform(translationX: 0, y: -240)
    } completion: { _ in
      toastView.removeFromSuperview()
    }
  }
}
