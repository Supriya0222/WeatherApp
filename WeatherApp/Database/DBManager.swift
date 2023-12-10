//
//  DBManager.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//

import Foundation
import CoreData

class DBManager: NSObject {
    public var databaseName: String = "WeatherApp"
    public static let shared : DBManager = DBManager(WithDatabaseName: "WeatherApp")
    
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
    
    func saveCurrentWeatherFor(region: String?, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) -> ForecastEntity {
        
        let region = region ?? WeatherViewModel.retrieveLocationFromUserDefaults()
        
        // Updating existing current for targeted location or creating a new one
        let newItem = fetchCurrentWeatherFor(region: region) ?? ForecastEntity(context: mainContext)

        newItem.region = region
        newItem.weather_type = weatherType
        newItem.temp_current = currentTemperature
        newItem.temp_min = minTemperature
        newItem.temp_max = maxTemperature
        newItem.timestamp = timestamp
        newItem.is_current = true
        try? mainContext.save()
        return newItem
    }
    
    func fetchCurrentWeatherFor(region: String?) -> ForecastEntity? {
        
        let region = region ?? WeatherViewModel.retrieveLocationFromUserDefaults()

        do {
            let fetchRequest = ForecastEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "region == %a AND is_current == YES", region ?? "")

            return try mainContext.fetch(fetchRequest).first
        } catch {
            return nil
        }

    }
    
    func saveForecastWeatherFor(region: String?, weatherType: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double, timestamp: Int32) -> ForecastEntity {
        
        let region = region ?? WeatherViewModel.retrieveLocationFromUserDefaults()
            
        let newItem = ForecastEntity(context: mainContext)
        newItem.region = region
        newItem.weather_type = weatherType
        newItem.temp_current = currentTemperature
        newItem.temp_min = minTemperature
        newItem.temp_max = maxTemperature
        newItem.timestamp = timestamp
        newItem.is_current = false
        try? mainContext.save()
        return newItem
    }
    
    func fetchWeatherForecastFor(region: String?) -> [ForecastEntity] {
        
        let region = region ?? WeatherViewModel.retrieveLocationFromUserDefaults()

        do {
            let fetchRequest = ForecastEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "region == %a AND is_current == NO", region ?? "")

            return try mainContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteWeatherForecast(_ region: String?) {
        let entities = fetchWeatherForecastFor(region: region)
        for entity in entities {
            mainContext.delete(entity)
        }
    }

}
