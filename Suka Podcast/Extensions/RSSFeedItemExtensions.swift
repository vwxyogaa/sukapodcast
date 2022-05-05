//
//  RSSFeedItemExtensions.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation
import FeedKit

typealias Audio = RSSFeedItem

extension RSSFeedItem {
  var url: String? {
    return enclosure?.attributes?.url
  }
  
  var pictureUrl: String? {
    return iTunes?.iTunesImage?.attributes?.href
  }
}
