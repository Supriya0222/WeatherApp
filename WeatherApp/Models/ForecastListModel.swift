//
//  ForecastListModel.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation


struct ForecastListModel: Codable {
    var list: [WeatherModel]? = []
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([WeatherModel].self, forKey: .list)
    }
    
    init() {
        
    }
}
