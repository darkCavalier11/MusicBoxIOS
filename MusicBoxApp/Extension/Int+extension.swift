//
//  Int+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 26/10/24.
//


extension Int {
  func convertToDuration() -> String {
    var duration = self
    let seconds = duration % 60
    duration /= 60
    let minutes = duration % 60
    duration /= 60
    let hours = duration
    if hours == 0 {
      return String(format: "%02d:%02d", minutes, seconds)
    }
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
