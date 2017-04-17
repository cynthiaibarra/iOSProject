//
//  LocationTracker.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/16/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation
import CoreLocation

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    private static let locManager:CLLocationManager = CLLocationManager()
    private static let instance:LocationTracker = LocationTracker()
    
    override private init() {
        super.init()
        LocationTracker.locManager.delegate = self
        LocationTracker.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        LocationTracker.locManager.distanceFilter = 100
    }
    
    static func getInstance () -> LocationTracker {
        
        return instance
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        //print("\(location.latitude)")
        //print("\(location.longitude)")
        
        let latitude:Double = location.latitude
        let longitude:Double = location.longitude
                
        DBHandler.addLocation(latitude: latitude, longitude: longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get Location: Location Tracker")
    }
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            
            if CLLocationManager.authorizationStatus() == .notDetermined {
                LocationTracker.locManager.requestAlwaysAuthorization()
            }
        }
        else {
            print("Location service is not enabled: Location Tracker")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if status == .authorizedAlways {
                print("Authorized for Always: Location Tracker")
            } else {
                print("Authorized for When In use: Location Tracker")
            }
            manager.startUpdatingLocation()
        } else {
            print("Not Authorized: Location Tracker")
        }
    }
    
}
