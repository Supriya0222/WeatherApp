//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var locationDidUpdate: ((CLLocation) -> Void)?

    override init() {
        super.init()
        setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationDidUpdate?(location)
        }
    }

    func isLocationPermissionGranted() -> Bool {
         return CLLocationManager.locationServicesEnabled() &&
             (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
             CLLocationManager.authorizationStatus() == .authorizedAlways)
     }
    
    var locationAuthorizationStatus: CLAuthorizationStatus {
           return CLLocationManager.authorizationStatus()
       }
     
     func requestLocationPermission() {
         locationManager.requestWhenInUseAuthorization()
     }
     
     func startUpdatingLocation() {
         locationManager.startUpdatingLocation()
     }
    
    func reverseGeocodeLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else {
                print("Reverse geocoding error: \(error!.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                if let locality = placemark.locality {
                    completion(locality)
                } else if let subLocality = placemark.subLocality {
                    completion(subLocality)
                } else if let name = placemark.name {
                    completion(name)
                } else {
                    completion(nil)
                }
            } else {
                print("No placemarks found.")
                completion(nil)
            }
        }
    }

    
}

