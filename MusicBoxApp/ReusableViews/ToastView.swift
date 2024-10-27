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
    label.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
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
    view.layer.cornerRadius = 6
    return view
  }()
  
  private lazy var backView2: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemYellow
    view.transform = CGAffineTransform(translationX: -2.5, y: 2.5)
    view.layer.cornerRadius = 6
    return view
  }()
  
  private lazy var backView3: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .tintColor
    view.transform = CGAffineTransform(translationX: -5, y: 5)
    view.layer.cornerRadius = 6
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(backView3)
    addSubview(backView2)
    addSubview(backView1)
    addSubview(label)
    self.backgroundColor = .darkText
    self.layer.cornerRadius = 6
    label.textColor = .lightText
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
      label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
      
      backView1.widthAnchor.constraint(equalTo: self.widthAnchor),
      backView1.heightAnchor.constraint(equalTo: self.heightAnchor),
      
      backView2.widthAnchor.constraint(equalTo: self.widthAnchor),
      backView2.heightAnchor.constraint(equalTo: self.heightAnchor),
      
      backView3.widthAnchor.constraint(equalTo: self.widthAnchor),
      backView3.heightAnchor.constraint(equalTo: self.heightAnchor),
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
