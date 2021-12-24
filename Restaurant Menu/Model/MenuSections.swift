//
//  MenuSections.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct MenuSections: Codable {
    
    enum CodingKeys: String, CodingKey {
        case menuItems = "menu_items"
        case sectionName = "section_name"
        case descriptionValue = "description"
    }
    
    var menuItems: [MenuItems]?
    var sectionName: String?
    var descriptionValue: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        menuItems = try container.decodeIfPresent([MenuItems].self, forKey: .menuItems)
        sectionName = try container.decodeIfPresent(String.self, forKey: .sectionName)
        descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
    }
}
