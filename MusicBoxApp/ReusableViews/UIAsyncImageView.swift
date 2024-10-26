//
//  UIAsyncImageView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 26/10/24.
//
import UIKit

class UIAsyncImageView: UIImageView {
  var imageURL: URL? {
    didSet {
      guard let imageURL else { return }
      DispatchQueue.main.async { [weak self] in
        guard let imagData = try? Data(contentsOf: imageURL) else { return }
        DispatchQueue.main.async {
          self?.image = UIImage(data: imagData)
        }
      }
    }
  }
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
