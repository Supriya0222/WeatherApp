//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewModel {
        
    let apiService = ApiService()
    var currentWeather: ForecastEntity?
    var forecastList: [ForecastEntity] = []
    
    var locationPermissionGranted: Bool {
        return LocationManager.shared.isLocationPermissionGranted()
    }
    
    var locationUpdateHandler: ((CLLocation, String?) -> Void)?
    
    var locationAccessDeniedHandler: (() -> Void)?
    
    var offlineHandler: (() -> Void)?
    
    func getForecastListFor(region: String?, latitude: Double, longitude: Double, successHandler: @escaping([ForecastEntity]) -> Void, failureHandler: @escaping(String?) -> Void) {
        
        apiService.requestForecastWeatherFor(latitude: latitude, longitude: longitude) { forecastList in
            
            guard let list = forecastList.list else {
                failureHandler("An error has occurred")
                return
            }
            self.forecastList.removeAll()
            DBManager.shared.deleteWeatherForecast(region)
            var previousTimestamp: Int32? = nil
            for weatherItem in list {
                guard let currentTemp = weatherItem.main?.temp, let minTemp = weatherItem.main?.tempMin, let maxTemp = weatherItem.main?.tempMax, let timeStamp = weatherItem.dt, let weatherType = weatherItem.weather?.first?.main else { return }
                
                if previousTimestamp == nil {
                    previousTimestamp = timeStamp
                }

                let dateResult = DateUtility.compareDayValues(timestamp1: Double(previousTimestamp!), timestamp2: Double(timeStamp))
                
                if dateResult != .orderedSame {
                    self.saveForecastWeather(region: region ?? "", weatherType: weatherType, currentTemperature: currentTemp, minTemperature: minTemp, maxTemperature: maxTemp, timestamp: timeStamp)
                    previousTimestamp = timeStamp
                }
                
            }
            successHandler(self.forecastList)
        } failureHandler: { errorMessage in
            failureHandler(errorMessage)
        }
    }
    
    func getCurrentWeatherFor(region: String?, latitude: Double, longitude: Double, successHandler: @escaping(ForecastEntity) -> Void, failureHandler: @escaping(String?) -> Void){
        apiService.requestCurrentWeatherFor(latitude: latitude, longitude: longitude) { currentWeather in
            guard let currentTemp = currentWeather.main?.temp, let minTemp = currentWeather.main?.tempMin, let maxTemp = currentWeather.main?.tempMax, let timeStamp = currentWeather.dt, let weatherType = currentWeather.weather?.first?.main else { return }
                        
            self.currentWeather = DBManager.shared.saveCurrentWeatherFor(region: region ?? "", weatherType: weatherType, currentTemperature: currentTemp, minTemperature: minTemp, maxTemperature: maxTemp, timestamp: timeStamp)
            
            successHandler(self.currentWeather!)
            
        } failureHandler: { errorMessage in
            failureHandler(errorMessage)
        }
    }
    
    func getCachedCurrentWeather(region: String?) -> ForecastEntity? {
        currentWeather = DBManager.shared.fetchCurrentWeatherFor(region: region)
        return currentWeather
    }
    
    func getCachedForecastWeather(region: String?) -> [ForecastEntity] {
        forecastList = DBManager.shared.fetchWeatherForecastFor(region: region)
        return forecastList
    }
    
    private func saveForecastWeather(region: String, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) {
        
        let cachedForecastWeather = DBManager.shared.saveForecastWeatherFor(region: region, weatherType: weatherType, currentTemperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, timestamp: timestamp)
        self.forecastList.append(cachedForecastWeather)
    }
    
    func checkLocationPermission() {
        if LocationManager.shared.isLocationPermissionGranted() {
            LocationManager.shared.startUpdatingLocation()
            
            LocationManager.shared.locationDidUpdate = { [weak self] location in
                
                self?.getRegion(location, completion: { regionName in
                    self?.locationUpdateHandler?(location, regionName)
                    })
                
                }
            
        } else {
            switch LocationManager.shared.locationAuthorizationStatus {
            case .notDetermined:
                LocationManager.shared.requestLocationPermission()
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.locationAccessDeniedHandler?()
                }
            default:
                DispatchQueue.main.async {
                    self.offlineHandler?()
                }
            }
        }
    }
    
    func requestLocationPermission() {
        LocationManager.shared.requestLocationPermission()
    }
        
    func saveLocationToUserDefaults(_ region: String) {
        
        UserDefaults.standard.set(region, forKey: DBManager.userDefaultsRegionKey)
        UserDefaults.standard.synchronize()
    }
    
    func getRegion(_ location: CLLocation, completion: @escaping (String?) -> Void) {
        LocationManager.shared.reverseGeocodeLocation(location: location) { region in
            completion(region)
        }
    }
    
    func getDateUpdated(_ dateTimestamp: Int32) -> String? {
        let date = DateUtility.formatDateFromTimestamp(timestamp: Double(dateTimestamp))
        return date 
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
        
    static func retrieveLocationFromUserDefaults() -> String?{
        return UserDefaults.standard.value(forKey: DBManager.userDefaultsRegionKey) as? String
    }

}
