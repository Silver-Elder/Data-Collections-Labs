//
//  Store Item Controller.swift
//  iTunesSearch
//
//  Created by Sterling Jenkins on 12/2/22.
//

import Foundation
import UIKit

class StoreItemController {
    enum storeItemError: Error, LocalizedError {
        case itemNotFound
        case imageDataMissing
    }
    
    func fetchItems(matching query: [String : String]) async throws -> [StoreItem] {
        
        var iTunesSearchURL = URLComponents(string: "https://itunes.apple.com/search")!
        
        iTunesSearchURL.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value)
        }
        
        let (data, response) = try await URLSession.shared.data(from: iTunesSearchURL.url!)
        
        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
            throw storeItemError.itemNotFound
        }
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601 // ISO (International Standard Organization) has developed a standard for displaying dates (e.x. "2007-10-09T07:00:00Z" (The Z means we're in the UTC timezone, although if I wanted to adjust my timezone, I could replace the z with "+(numebr of hours)", or "-(numebr of hours)" to offset my hours from the UTC time zone)). This line of command tells the "Date" class to treat my JSON's returned date objects as dates formatted in this iso8601 format, rather than in a standard Double format.
        
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
    
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw storeItemError.imageDataMissing
        }
    
        guard let image = UIImage(data: data) else {
            throw storeItemError.imageDataMissing
        }
    
        return image
    }
}
