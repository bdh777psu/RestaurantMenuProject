//
//  Geo.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Geo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    var lat: Float?
    var lon: Float?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decodeIfPresent(Float.self, forKey: .lat)
        lon = try container.decodeIfPresent(Float.self, forKey: .lon)
    }
}
