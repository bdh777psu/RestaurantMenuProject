//
//  Menus.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation

struct Menus: Codable {
    
    enum CodingKeys: String, CodingKey {
        case menuName = "menu_name"
        case menuSections = "menu_sections"
    }
    
    var menuName: String?
    var menuSections: [MenuSections]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        menuName = try container.decodeIfPresent(String.self, forKey: .menuName)
        menuSections = try container.decodeIfPresent([MenuSections].self, forKey: .menuSections)
    }
}
