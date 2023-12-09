//
//  DBManager.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//

import Foundation
import CoreData

class DBManager: NSObject {
    public var databaseName: String = "WeatherModel"
    public static let shared : DBManager = DBManager(WithDatabaseName: "WeatherModel")
    
    init(WithDatabaseName name: String){
        super.init()
        self.databaseName = name
        
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: self.databaseName)
        
        container.loadPersistentStores(completionHandler: { (storeDes, error) in
            if let error = error as? NSError{
                print(error)
            }
        })
        return container

    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func saveCurrentWeatherFor(latitude: Double?, longitude: Double?, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) -> ForecastEntity {
        
        //Save latitude and longitude in nsuserdefaults in case of offline
        let latitude = latitude ?? 0.0
        let longitude = longitude ?? 0.0
        
        // Updating existing current for targeted location or creating a new one
        let newItem = fetchCurrentWeatherFor(latitude: latitude, longitude: longitude) ?? ForecastEntity(context: mainContext)
        newItem.latitude = latitude
        newItem.longitude = longitude
        newItem.weather_type = weatherType
        newItem.temp_current = currentTemperature
        newItem.temp_min = minTemperature
        newItem.temp_max = maxTemperature
        newItem.timestamp = timestamp
        newItem.is_current = true
        try? mainContext.save()
        return newItem
    }
    
    func fetchCurrentWeatherFor(latitude: Double?, longitude: Double?) -> ForecastEntity? {
        
        //Save latitude and longitude in nsuserdefaults in case of offline
        let targetLatitude = latitude ?? 0.0
        let targetLongitude = longitude ?? 0.0

        do {
            let fetchRequest = ForecastEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "latitude == %f AND longitude == %f AND is_current == YES", targetLatitude, targetLongitude)

            return try mainContext.fetch(fetchRequest).first
        } catch {
            return nil
        }

    }
    
    func saveForecastWeatherFor(latitude: Double?, longitude: Double?, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) -> ForecastEntity {
        
        //Save latitude and longitude in nsuserdefaults in case of offline
        let latitude = latitude ?? 0.0
        let longitude = longitude ?? 0.0
        
        let newItem = ForecastEntity(context: mainContext)
        newItem.latitude = latitude
        newItem.longitude = longitude
        newItem.weather_type = weatherType
        newItem.temp_current = currentTemperature
        newItem.temp_min = minTemperature
        newItem.temp_max = maxTemperature
        newItem.timestamp = timestamp
        newItem.is_current = false
        try? mainContext.save()
        return newItem
    }
    
    func fetchWeatherForecastFor(latitude: Double?, longitude: Double?) -> [ForecastEntity] {
        
        //Save latitude and longitude in nsuserdefaults in case of offline
        let targetLatitude = latitude ?? 0.0
        let targetLongitude = longitude ?? 0.0

        do {
            let fetchRequest = ForecastEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "latitude == %f AND longitude == %f AND is_current == NO", targetLatitude, targetLongitude)

            return try mainContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteWeatherForecast(_ latitude: Double?, longitude: Double?) {
        let entities = fetchWeatherForecastFor(latitude: latitude, longitude: longitude)
        for entity in entities {
            mainContext.delete(entity)
        }
    }

}
