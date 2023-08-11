//
//  MenuController.swift
//  OrderApp
//
//  Created by Marwan Hazem on 08/08/2023.
//

import Foundation
import UIKit

class MenuController {
    let baseUrl = URL(string: "http://localhost:8080/")!
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name:
               MenuController.orderUpdatedNotification, object: nil)
        }
    }
    static let shared = MenuController()
    static let orderUpdatedNotification =
       Notification.Name("MenuController.orderUpdated")
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
    
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw MenuControllerError.imageDataMissing
        }
    
        guard let image = UIImage(data: data) else {
            throw MenuControllerError.imageDataMissing
        }
    
        return image
    }
    func fetchCategories() async throws -> [String] {
        let categoriesURL = baseUrl.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from:
               categoriesURL)

        enum MenuControllerError: Error, LocalizedError {
            case categoriesNotFound
        }
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        let decoder = JSONDecoder()
        let categoriesResponse = try decoder.decode(CategoriesResponse.self,
           from: data)
        return categoriesResponse.categories
    }
    
    
    func fetchMenuItems(forCategory categoryName: String) async throws ->
    [MenuItem] {
        
        enum MenuControllerError: Error, LocalizedError {
            case categoriesNotFound
            case menuItemsNotFound
        }
        let baseMenuURL = baseUrl.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL,
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category",
                                              value: categoryName)]
        let menuURL = components.url!
        let (data, response) = try await URLSession.shared.data(from:menuURL)
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }

    typealias MinutesToPrepare = Int
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws ->
    MinutesToPrepare {
        
        let orderURL = baseUrl.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let menuIdsDict = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        
        enum MenuControllerError: Error, LocalizedError {
            case categoriesNotFound
            case menuItemsNotFound
            case orderRequestFailed
        }
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        return orderResponse.prepTime
    }
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        case imageDataMissing
    }
   

}
