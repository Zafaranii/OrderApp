//
//  ResponseModel.swift
//  OrderApp
//
//  Created by Marwan Hazem on 08/08/2023.
//

import Foundation



struct MenuResponse: Codable {
    let items: [MenuItem]
}



struct CategoriesResponse: Codable {
    let categories: [String]
}


struct OrderResponse: Codable {
    let prepTime: Int
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
