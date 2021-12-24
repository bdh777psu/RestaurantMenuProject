//
//  MenuItems.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct MenuItems: Codable {
    
    enum CodingKeys: String, CodingKey {
        case price
        case name
        case descriptionValue = "description"
        case pricing
    }
    
    var price: Float?
    var name: String?
    var descriptionValue: String?
    var pricing: [Pricing]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        price = try container.decodeIfPresent(Float.self, forKey: .price)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
        pricing = try container.decodeIfPresent([Pricing].self, forKey: .pricing)
    }
}
