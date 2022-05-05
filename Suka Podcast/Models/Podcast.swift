//
//  Podcast.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation

struct Podcast: Decodable {
  let collectionId: Int
  let trackId: Int
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl30: String
  let artworkUrl60: String
  let artworkUrl100: String
  let artworkUrl600: String
  let genres: [String]
  let feedUrl: String
  
  enum CodingKeys: String, CodingKey {
    case collectionId
    case trackId
    case artistName
    case collectionName
    case trackName
    case artworkUrl30
    case artworkUrl60
    case artworkUrl100
    case artworkUrl600
    case genres
    case feedUrl
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    collectionId = try container.decodeIfPresent(Int.self, forKey: .collectionId) ?? 0
    trackId = try container.decodeIfPresent(Int.self, forKey: .trackId) ?? 0
    artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? ""
    collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
    trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
    artworkUrl30 = try container.decodeIfPresent(String.self, forKey: .artworkUrl30) ?? ""
    artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
    artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
    artworkUrl600 = try container.decodeIfPresent(String.self, forKey: .artworkUrl600) ?? ""
    genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
    feedUrl = try container.decodeIfPresent(String.self, forKey: .feedUrl) ?? ""
  }
}
