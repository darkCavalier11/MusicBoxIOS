//
//  UIFont+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 22/10/24.
//

import UIKit

extension UIFont {
  class func preferredCustomFont(
    forTextStyle style: UIFont.TextStyle,
    fontName: String? = "RethinkSans-Medium",
    weight: Weight = .regular,
    size: CGFloat? = nil
  ) -> UIFont {
    // 1
    let metrics = UIFontMetrics(forTextStyle: style)
    // 2
    let descriptor = preferredFont(forTextStyle: style).fontDescriptor
    let defaultSize = descriptor.pointSize
    // 3
    let fontToScale: UIFont
    if let fontName = fontName,
       let font = UIFont(name: fontName, size: size ?? defaultSize)
    {
      fontToScale = font
    } else {
      fontToScale = UIFont.systemFont(ofSize: size ?? defaultSize, weight: weight)
    }
    // 4
    return metrics.scaledFont(for: fontToScale)
  }
}
