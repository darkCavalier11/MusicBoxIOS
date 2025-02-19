//
//  FileManager+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 19/11/24.
//

import Foundation

extension FileManager {
  var documentURL: URL {
    return self.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}
