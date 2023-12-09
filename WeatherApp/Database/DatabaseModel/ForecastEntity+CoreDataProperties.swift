//
//  ForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var is_current: Bool
    @NSManaged public var temp_current: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var timestamp: Int32
    @NSManaged public var weather_type: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension ForecastEntity : Identifiable {

}
