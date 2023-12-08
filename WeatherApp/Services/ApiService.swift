//
//  ApiService.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation

class ApiService {
    //Unique api key required for api request
    let apiId = "ad5ca998961f5a73c2a23cf0bd2aa311"
    let baseUrl = "https://api.openweathermap.org"
    
    enum EndpointType {
        case current
        case forecast
    }
    
    func getUrlForCase(_ value: EndpointType, latitude: Double, longitude: Double) -> String {
        switch value {
        case .current:
            return "\(baseUrl)/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiId)"
        case .forecast:
            return "\(baseUrl)/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiId)"
        }
    }
    
    enum HttpMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    func apiRequestFor(url: String, httpMethod: HttpMethod,  completed: @escaping (_ data :Any?, _ error: String?) -> Void){
        
        guard let requestUrl = URL(string: url) else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = httpMethod.rawValue
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completed(nil, error.localizedDescription)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    if httpResponse?.statusCode == 200 {
                        completed(data, "")
                    } else {
                        //Generic error message
                        completed(nil, "An error has occurred. Please try again later.")
                    }
                }
            }
        }
            task.resume()
    }
    
}


// MARK: - API REQUESTS FOR WEATHER FORECASTS
extension ApiService {
    
    func requestCurrentWeatherFor(latitude: Double, longitude: Double, successHandler: @escaping (WeatherModel) -> Void, failureHandler: @escaping (String?) -> Void) {
        
        let url = getUrlForCase(.current, latitude: latitude, longitude: longitude)
        
        apiRequestFor(url: url, httpMethod: .get) { data, error in
            if let errorMessage = error {
                failureHandler(errorMessage)
                return
            }
            
            guard let currentModel = try?
                    JSONDecoder().decode(WeatherModel.self, from: data as? Data ?? Data()) else {
                failureHandler(nil)
                return
            }
            successHandler(currentModel)
        }
    }
    
    func requestForecastWeatherFor(latitude: Double, longitude: Double, successHandler: @escaping (ForecastListModel) -> Void, failureHandler: @escaping (String?) -> Void) {
        
        let url = getUrlForCase(.forecast, latitude: latitude, longitude: longitude)
        
        apiRequestFor(url: url, httpMethod: .get) { data, error in
            if let errorMessage = error, !errorMessage.isEmpty {
                failureHandler(errorMessage)
                return
            }

            guard let forecastListModel = try?
                    JSONDecoder().decode(ForecastListModel.self, from: data as? Data ?? Data()) else {
                failureHandler(nil)
                return
            }
            successHandler(forecastListModel)
            
        }
    }
}

