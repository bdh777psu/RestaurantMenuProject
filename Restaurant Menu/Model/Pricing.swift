//
//  Pricing.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Pricing: Codable {
    
    enum CodingKeys: String, CodingKey {
        case price
        case currency
        case priceString
    }
    
    var price: Double?
    var currency: String?
    var priceString: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        priceString = try container.decodeIfPresent(String.self, forKey: .priceString)
    }
}
