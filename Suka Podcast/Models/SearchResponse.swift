//
//  SearchResponse.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation

struct SearchResponse: Decodable {
  let resultCount: Int
  let results: [Podcast]
  
  enum CodingKeys: String, CodingKey {
    case resultCount
    case results
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount) ?? 0
    results = try container.decodeIfPresent([Podcast].self, forKey: .results) ?? []
  }
}
