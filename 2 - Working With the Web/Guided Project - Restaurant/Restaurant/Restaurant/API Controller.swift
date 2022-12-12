//
//  API Controller.swift
//  Restaurant
//
//  Created by Sterling Jenkins on 12/8/22.
//

import Foundation
import UIKit

class APIController {
    
    enum errors: Error {
        case itemNotFound
        case imageNotFound
    }
    
    func fetchCategories() async throws -> Categories {
        let url = URL(string: "http://localhost:8080/categories")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.itemNotFound
        }
        
        let decoder = JSONDecoder()
        
        let categories = try decoder.decode(Categories.self, from: data)
        
        return categories
    }
    
    func fetchMenu() async throws -> MenuItem {
        let url = URL(string: "http://localhost:8080/menu")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.itemNotFound
        }
        
        let decoder = JSONDecoder()
        
        let menu = try decoder.decode(MenuItem.self, from: data)
        
        return menu
    }
    
    func fetchPhoto(from url: URL) async throws -> UIImage{
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.imageNotFound
        }
        
        guard let photo = UIImage(data: data) else {
            throw errors.imageNotFound
        }
        
        return photo
    }
    
    func fetchPreparationTime() async throws {
        
    }
}
