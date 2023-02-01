//
//  Data Formatters.swift
//  Restaurant
//
//  Created by Sterling Jenkins on 12/8/22.
//

import Foundation
import UIKit


    struct Categories: Codable {
        var categories: [String]
        
        enum CodingKeys: String, CodingKey {
            case categories
            
        }
    }
    
    struct MenuItems: Codable {
        var items: [MenuItem]
    }

    struct MenuItem: Codable {
        var category: String
        var id: Int
        var image: URL
        var title: String
        var description: String
        var price: Double
        
        enum CodingKeys: String, CodingKey {
            case category
            case id
            case image = "image_url"
            case title = "name"
            case description
            case price
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            category = try values.decode(String.self, forKey: CodingKeys.category)
            id = try values.decode(Int.self, forKey: CodingKeys.id)
            image = try values.decode(URL.self, forKey: CodingKeys.image)
            title = try values.decode(String.self, forKey: CodingKeys.title)
            description = try values.decode(String.self, forKey: CodingKeys.description)
            price = try values.decode(Double.self, forKey: CodingKeys.price)
        }
    }
    
    struct PreparationTime: Codable {
        var preparationTime: Int
        
        enum CodingKeys: String, CodingKey {
            case preparationTime = "preparation_time"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            preparationTime = try values.decode(Int.self, forKey: CodingKeys.preparationTime)
        }
    }

    struct Order: Codable {
        var menuItems: [MenuItem]
    }

    struct OrderResponse: Codable {
        let prepTime: Int
        
        enum CodingKeys: String, CodingKey {
            case prepTime = "preparation_time"
        }
    }

