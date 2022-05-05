//
//  iTunesProvider.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation
import Alamofire
import FeedKit

private let baseUrl = "https://itunes.apple.com/search"

class iTunesProvider {
  static var shared: iTunesProvider = iTunesProvider()
  private init() { }
  
  func search(_ term: String, media: String = "podcast", limit: Int = 50, completion: @escaping (Result<[Podcast], Error>) -> Void) {
    let parameterSearch: [String: Any] = ["term": term, "media": media, "limit": limit]
    AF.request(
      baseUrl,
      method: .get,
      parameters: parameterSearch
    ).validate().responseDecodable(of: SearchResponse.self) { response in
      switch response.result {
      case .success(let value):
        completion(.success(value.results))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func loadFromFeedUrl(_ url: String, completion: @escaping (Result<RSSFeed?, Error>) -> Void) {
    let feedURL = URL(string: url)!
    let parser = FeedParser(URL: feedURL)
    parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let feed):
          let rssFeed = feed.rssFeed
          completion(.success(rssFeed))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
}
