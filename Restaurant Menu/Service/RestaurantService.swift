//
//  RestaurantWebService.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Foundation
import SwiftUI

struct RestaurantService {
    
    //MARK: Service Base Values
    private let baseURL: String = "https://api.documenu.com/v2"
    private let endpoint: String = "/restaurants/search/geo"
    private let apiKey: String = "864d4a63cd405a759871905a95ac9d60"
    
    //MARK: Service Default Values
    private let distance: String = "&distance=1"
    private let size: String = "&size=1"
    private let page: String = "&page=1"
    private let fullMenu: String = "&fullmenu=true"
    
    //MARK: Requests
    func fetchRestaurantData(lat: String, lon: String) {
        let urlString = baseURL + endpoint
        let location = "?" + "lat=\(lat)" + "&lon=\(lon)"
        let key = "&key=" + apiKey
        
        let fullURL = urlString + location + distance + size + page + fullMenu + key
        
        performRequest(for: fullURL)
    }

    private func performRequest(for address: String) {
        if let url = URL(string: address) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error)
                }
                
                if let data = data {
                    let response = String(data: data, encoding: .utf8)
                    print(response)
                }
            }
            
            task.resume()
        }
    }
}
