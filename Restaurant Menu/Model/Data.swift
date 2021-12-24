//
//  Data.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Data: Codable {
    
    enum CodingKeys: String, CodingKey {
        case restaurantPhone = "restaurant_phone"
        case geo
        case menus
        case restaurantWebsite = "restaurant_website"
        case address
        case restaurantId = "restaurant_id"
        case restaurantName = "restaurant_name"
        case hours
        case lastUpdated = "last_updated"
        case cuisines
        case priceRangeNum = "price_range_num"
        case priceRange = "price_range"
    }
    
    var restaurantPhone: String?
    var geo: Geo?
    var menus: [Menus]?
    var restaurantWebsite: String?
    var address: Address?
    var restaurantId: Int?
    var restaurantName: String?
    var hours: String?
    var lastUpdated: String?
    var cuisines: [String]?
    var priceRangeNum: Int?
    var priceRange: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantPhone = try container.decodeIfPresent(String.self, forKey: .restaurantPhone)
        geo = try container.decodeIfPresent(Geo.self, forKey: .geo)
        menus = try container.decodeIfPresent([Menus].self, forKey: .menus)
        restaurantWebsite = try container.decodeIfPresent(String.self, forKey: .restaurantWebsite)
        address = try container.decodeIfPresent(Address.self, forKey: .address)
        restaurantId = try container.decodeIfPresent(Int.self, forKey: .restaurantId)
        restaurantName = try container.decodeIfPresent(String.self, forKey: .restaurantName)
        hours = try container.decodeIfPresent(String.self, forKey: .hours)
        lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
        cuisines = try container.decodeIfPresent([String].self, forKey: .cuisines)
        priceRangeNum = try container.decodeIfPresent(Int.self, forKey: .priceRangeNum)
        priceRange = try container.decodeIfPresent(String.self, forKey: .priceRange)
    }
}
