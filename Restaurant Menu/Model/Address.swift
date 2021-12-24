//
//  Address.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Address: Codable {
    
    enum CodingKeys: String, CodingKey {
        case street
        case postalCode = "postal_code"
        case formatted
        case city
        case state
    }
    
    var street: String?
    var postalCode: String?
    var formatted: String?
    var city: String?
    var state: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decodeIfPresent(String.self, forKey: .street)
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        formatted = try container.decodeIfPresent(String.self, forKey: .formatted)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        state = try container.decodeIfPresent(String.self, forKey: .state)
    }
}
