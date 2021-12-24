//
//  RestaurantWebService.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import Alamofire
import Foundation

protocol RestaurantServiceDelegate {
    func didUpdateRestaurant(_ restaurant: Restaurant)
    func didFailWithError(_ error: Error)
}

struct RestaurantManager {

    // MARK: Service Base Values
    private let baseURL: String = "https://api.documenu.com/v2"
    private let endpoint: String = "/restaurants/search/geo"
    private let apiKey: String = "864d4a63cd405a759871905a95ac9d60"

    // MARK: Service Default Values
    private let distance: String = "&distance=1"
    private let size: String = "&size=1"
    private let page: String = "&page=1"
    private let fullMenu: String = "&fullmenu=true"

    var delegate: RestaurantServiceDelegate?

    // MARK: Requests
    func fetchRestaurantData(lat: String, lon: String) {
        let urlString = baseURL + endpoint
        let location = "?" + "lat=\(lat)" + "&lon=\(lon)"
        let key = "&key=" + apiKey

        let fullURL = urlString + location + distance + size + page + fullMenu + key
        print(fullURL)

        performRequest(for: fullURL)
    }

    private func performRequest(for url: String) {
        AF.request(url).responseDecodable(of: Restaurant.self) { response in
            switch response.result {
            case .success(let value):
                delegate?.didUpdateRestaurant(value)
            case .failure(let error):
                delegate?.didFailWithError(error)
            }
        }
    }
}
