//
//  DateExtensions.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation

extension Date {
  func string(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: self)
  }
}
