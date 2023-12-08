//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation

struct WeatherModel: Codable {
    
    var weather: [Weather]? = []
    var main: Main? = Main()
    var dt: Int32? = nil
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case dt = "dt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        dt = try values.decodeIfPresent(Int32.self, forKey: .dt)
    }
    
    init() {
        
    }
    
    
    struct Weather: Codable {
        var main: String? = nil
        
        enum CodingKeys: String, CodingKey {
            case main = "main"
            
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            main = try values.decodeIfPresent(String.self, forKey: .main)
        }
        
        init() {
            
        }
    }
    
    
    struct Main: Codable {
        var temp: Double? = nil
        var tempMin: Double? = nil
        var tempMax: Double? = nil
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            temp = try values.decodeIfPresent(Double.self, forKey: .temp)
            tempMin = try values.decodeIfPresent(Double.self, forKey: .tempMin)
            tempMax = try values.decodeIfPresent(Double.self, forKey: .tempMax)
        }
        
        init() {
            
        }
    }
    
    
}
