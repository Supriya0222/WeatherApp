//
//  DateUtility.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//

import Foundation

class DateUtility {
    
    static func compareDayValues(timestamp1: TimeInterval, timestamp2: TimeInterval) -> ComparisonResult {
        let calendar = Calendar.current

        let date1 = Date(timeIntervalSince1970: timestamp1)
        let date2 = Date(timeIntervalSince1970: timestamp2)

        let day1 = calendar.component(.day, from: date1)
        let day2 = calendar.component(.day, from: date2)

        // Compare day values
        if day1 == day2 {
            return .orderedSame
        } else if day1 < day2 {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }
    
   static func getDayOfWeek(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") 
        return dateFormatter.weekdaySymbols[weekday - 1]
    }
    
    static func formatDateFromTimestamp(timestamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current // You can set the desired time zone
        
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}
