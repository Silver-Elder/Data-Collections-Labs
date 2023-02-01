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
        case categoriesNotFound
        case menusNotFound
        case orderRequestFailed
        case imageNotFound
        
    }
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func fetchCategories() async throws -> Categories {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.categoriesNotFound
        }
        
        let decoder = JSONDecoder()
        
        let categories = try decoder.decode(Categories.self, from: data)
        
        return categories
    }
    
    func fetchMenu(filterBy: String) async throws -> [MenuItem] {
        let menuURL = baseURL.appendingPathComponent("menu")
        
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.menusNotFound
        }
        
        let decoder = JSONDecoder()
        
        let menu = try decoder.decode(MenuItems.self, from: data).items.filter({$0.category == filterBy})
        
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
    
    typealias MinutesToPrepare = Int
    
    func fetchPreparationTime(formenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("applcation/json", forHTTPHeaderField: "Content-Type")
        
        let menuIdsDict = ["menuIds": menuIDs]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errors.orderRequestFailed
        }
        
        let decoder = JSONDecoder()
        
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
}
