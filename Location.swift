//
//  Location.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
class Location: NSManagedObject {
    static let entityName = "\(Location.self)"
    private let manager = LocationManager()
    
    convenience init?(latitude: Double, longitude: Double, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        let context = CoreDataController.sharedInstance.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
        self.latitude = latitude
        self.longitude = longitude

        self.manager.getPlacemarks(location: self.clLoc) { (placemarks, error) in
            if let placemarks = placemarks {
                if let placemark = placemarks.first {
                    self.placemark = placemark.myDescription
                } else {
                    if let error = error {
                        self.placemark = "\(error)"
                    }
                }
            }
            completion(placemarks, error)
        }
    }
    
    convenience init?(clLocation: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        self.init(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude, completion: completion)
    }
    
    class func location(latitude: Double, longitude: Double) -> Location {
        let location: Location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
        location.latitude = latitude
        location.longitude = longitude
        return location
    }
    
    static let allLocationsRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Location.entityName)
        return request
    }()
}

extension Location {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var placemark: String
}

extension Location {
    var clLoc: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
