//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation

class WeatherViewModel {
    //Constants
    let numberOfRows = 5
    
    let locationService = LocationManager()
    
    let apiService = ApiService()
    
    func getForecastListFor(latitude: Double, longitude: Double, completionHandler: @escaping([WeatherModel], String?) -> Void) {
        
        apiService.requestForecastWeatherFor(latitude: -26.2041028, longitude: 28.0473051) { forecastList in

        } failureHandler: { errorMessage in
            print(errorMessage)
        }
    }
    
}
