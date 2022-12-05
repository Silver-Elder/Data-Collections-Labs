//
//  Store Item.swift
//  iTunesSearch
//
//  Created by Sterling Jenkins on 12/2/22.
//

import Foundation

struct StoreItem: Codable {
    var artistName: String
    var artworkURL: URL
    var releaseDate: Date
    var trackName: String
    var trackTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case artworkURL = "artworkUrl60"
        case releaseDate
        case trackName
        case trackTime = "trackTimeMillis"
    }
        
    // Let's create a custom initializer for fun!!!
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
        artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)
        releaseDate = try values.decode(Date.self, forKey: CodingKeys.releaseDate)
        trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
        if let trackTimeMili = try? values.decode(Double.self, forKey: CodingKeys.trackTime) {
            trackTime = ((trackTimeMili / 1000 / 60) * 100).rounded() / 100
        }
    }
    
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}
