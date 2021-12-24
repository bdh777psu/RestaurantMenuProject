//
//  Restaurant.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Restaurant: Codable {

    enum CodingKeys: String, CodingKey {
        case totalResults
        case numResults
        case data
        case page
        case totalPages = "total_pages"
        case morePages = "more_pages"
    }
    
    var totalResults: Int?
    var numResults: Int?
    var data: [Data]?
    var page: String?
    var totalPages: Int?
    var morePages: Bool?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        numResults = try container.decodeIfPresent(Int.self, forKey: .numResults)
        data = try container.decodeIfPresent([Data].self, forKey: .data)
        page = try container.decodeIfPresent(String.self, forKey: .page)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        morePages = try container.decodeIfPresent(Bool.self, forKey: .morePages)
    }
}
