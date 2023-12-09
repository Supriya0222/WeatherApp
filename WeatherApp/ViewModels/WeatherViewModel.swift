//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation
import UIKit

class WeatherViewModel {
    //Used for testing purposes
    //lat: -26.2041028
    //long: 28.0473051
        
    let locationService = LocationManager()
    let apiService = ApiService()
    var currentWeather: ForecastEntity?
    var forecastList: [ForecastEntity] = []
    
    func getForecastListFor(latitude: Double, longitude: Double, successHandler: @escaping([ForecastEntity]) -> Void, failureHandler: @escaping(String?) -> Void) {
        
        apiService.requestForecastWeatherFor(latitude: latitude, longitude: longitude) { forecastList in
            
            guard let list = forecastList.list else {
                failureHandler("An error has occurred")
                return
            }
            var previousTimestamp: Int32? = nil
            for weatherItem in list {
                guard let currentTemp = weatherItem.main?.temp, let minTemp = weatherItem.main?.tempMin, let maxTemp = weatherItem.main?.tempMax, let timeStamp = weatherItem.dt, let weatherType = weatherItem.weather?.first?.main else { return }
                
                if previousTimestamp == nil {
                    self.saveForecastWeather(latitude: latitude, longitude: longitude, weatherType: weatherType, currentTemperature: currentTemp, minTemperature: minTemp, maxTemperature: maxTemp, timestamp: timeStamp)

                    previousTimestamp = timeStamp
                }

                let dateResult = DateUtility.compareDayValues(timestamp1: Double(previousTimestamp!), timestamp2: Double(timeStamp))
                
                if dateResult != .orderedSame {
                    self.saveForecastWeather(latitude: latitude, longitude: longitude, weatherType: weatherType, currentTemperature: currentTemp, minTemperature: minTemp, maxTemperature: maxTemp, timestamp: timeStamp)
                    previousTimestamp = timeStamp
                }
                
            }
            
            successHandler(self.forecastList)
            
        } failureHandler: { errorMessage in
            failureHandler(errorMessage)
        }
    }
    
    func getCurrentWeatherFor(latitude: Double, longitude: Double, successHandler: @escaping(ForecastEntity) -> Void, failureHandler: @escaping(String?) -> Void){
        apiService.requestCurrentWeatherFor(latitude: latitude, longitude: longitude) { currentWeather in
            guard let currentTemp = currentWeather.main?.temp, let minTemp = currentWeather.main?.tempMin, let maxTemp = currentWeather.main?.tempMax, let timeStamp = currentWeather.dt, let weatherType = currentWeather.weather?.first?.main else { return }
            
            self.currentWeather = DBManager.shared.saveCurrentWeatherFor(latitude: latitude, longitude: longitude, weatherType: weatherType, currentTemperature: currentTemp, minTemperature: minTemp, maxTemperature: maxTemp, timestamp: timeStamp)
            
            successHandler(self.currentWeather!)
            
        } failureHandler: { errorMessage in
            failureHandler(errorMessage)
        }
    }
    
    func getCachedCurrentWeather(latitude: Double?, longitude: Double?) -> ForecastEntity? {
        currentWeather = DBManager.shared.fetchCurrentWeatherFor(latitude: latitude, longitude: longitude)
        return currentWeather
    }
    
    func getCachedForecastWeather(latitude: Double?, longitude: Double?) -> [ForecastEntity] {
        forecastList = DBManager.shared.fetchWeatherForecastFor(latitude: latitude, longitude: longitude)
        return forecastList
    }
    
    private func saveForecastWeather(latitude: Double, longitude: Double, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) {
        
        let cachedForecastWeather = DBManager.shared.saveForecastWeatherFor(latitude: latitude, longitude: longitude, weatherType: weatherType, currentTemperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, timestamp: timestamp)
        self.forecastList.append(cachedForecastWeather)
    }
    
    static func getWeatherTypeDetailsFor(_ type: String) -> (backgroundColor: UIColor, backgroundImage: UIImage?, iconImage: UIImage?, weatherType: String) {
        switch type {
            case "Clear":
                return (
                    StyleGuide.sunnyColor ?? UIColor.white,
                    UIImage(named: "forest_sunny"),
                    UIImage(named: "clear"),
                    "Sunny"
                )
            case "Clouds":
                return (
                    StyleGuide.cloudyColor ?? UIColor.white,
                    UIImage(named: "forest_cloudy"),
                    UIImage(named: "partly_sunny"),
                    "Cloudy"
                )
            default:
                return (
                    StyleGuide.rainyColor ?? UIColor.white,
                    UIImage(named: "forest_rainy"),
                    UIImage(named: "rain"),
                    "Rainy"
                )
        }
    }
    

}
