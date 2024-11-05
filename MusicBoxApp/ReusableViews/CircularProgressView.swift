//
//  ArcView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 05/11/24.
//


import UIKit

class CircularProgressView: UIView {
  private struct Appearance {
    static let lineWidth = 6.0
    static let backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
    static let progressColor = UIColor.systemYellow
  }
  
  private lazy var progressLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = Appearance.lineWidth
    layer.lineCap = .round
    layer.strokeStart = 0
    layer.strokeEnd = 0
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = Appearance.progressColor.cgColor
    return layer
  }()
  
  private lazy var backgroundLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = Appearance.lineWidth
    layer.lineCap = .round
    layer.strokeStart = 0
    layer.strokeEnd = 1
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = Appearance.backgroundColor.cgColor
    
    return layer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func loadLayout() {
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(progressLayer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let circlePath = UIBezierPath(
      arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
      radius: (bounds.width - Appearance.lineWidth),
      startAngle: -Double.pi / 2,
      endAngle: Double.pi * 3 / 2,
      clockwise: true
    )
      .cgPath
    
    backgroundLayer.path = circlePath
    progressLayer.path = circlePath
  }
  
  func setProgres(_ progress: CGFloat, animated: Bool) {
    let clampedProgress = max(min(progress, 1), 0)
    
    if animated {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = progressLayer.strokeEnd
      animation.toValue = clampedProgress
      animation.duration = 0.5
      animation.timingFunction = CAMediaTimingFunction(name: .linear)
      progressLayer.removeAnimation(forKey: "progress")
      progressLayer.add(animation, forKey: "progress")
    }
    
    progressLayer.strokeEnd = clampedProgress
  }
}
