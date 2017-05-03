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
    private var currentEventID:String = " "
    private static var tracking:Bool = false;
    
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
        
        if(currentEventID != " ") {
            DBHandler.addLocation(latitude: latitude, longitude: longitude, eventID: currentEventID)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get Location: Location Tracker")
    }
    
    func requestLocation(eventID:String) {
        
        currentEventID = eventID
        //print(currentEventID)
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == .notDetermined {
                LocationTracker.locManager.requestAlwaysAuthorization()
            }
            else if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                LocationTracker.locManager.startUpdatingLocation()
                LocationTracker.tracking = true
            }
        }
        else {
            print("Location service is not enabled: Location Tracker")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse) && currentEventID != " " {
            if status == .authorizedAlways {
                print("Authorized for Always: Location Tracker")
            } else {
                print("Authorized for When In use: Location Tracker")
            }
            manager.startUpdatingLocation()
            LocationTracker.tracking = true
        } else {
            print("Not Authorized: Location Tracker")
        }
    }
    
    func stopTracking() {
        LocationTracker.tracking = false
        currentEventID = " "
        print("Stopping Location Tracking")
        LocationTracker.locManager.stopUpdatingLocation()
    }
    
    func isTracking() -> Bool {
        
        return LocationTracker.tracking
    }
    
}
