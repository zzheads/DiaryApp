//
//  LocationManager.swift
//  DiaryApp
//
//  Created by Alexey Papin on 09.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    static let sharedInstance = LocationManager()
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    init() {}
    
    var isAuthorized: Bool {
        switch (CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .notDetermined, .restricted: return false
        }
    }

    func getPlacemarks(location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        self.geocoder.reverseGeocodeLocation(location, completionHandler: completion)
    }
    
    var location: CLLocation? {
        return self.manager.location
    }
    
    func requestAuthorization() {
        self.manager.requestWhenInUseAuthorization()
    }
}
