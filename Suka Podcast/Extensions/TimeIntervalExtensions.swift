//
//  TimeIntervalExtensions.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation

extension TimeInterval {
  var string: String {
    let timeInterval = Int(self)
    
    let seconds = timeInterval % 60
    let minutes = (timeInterval / 60) % 60
    let hours = (timeInterval / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
  }
}
