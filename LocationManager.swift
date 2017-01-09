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
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    init() {
        if (CLLocationManager.authorizationStatus() != .authorizedWhenInUse) {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func getPlacemarks(location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            self.geocoder.reverseGeocodeLocation(location, completionHandler: completion)
        }
    }
    
    var location: CLLocation? {
        return self.manager.location
    }
}
