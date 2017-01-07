//
//  Location.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData

@objc(Location)
class Location: NSManagedObject {
    static let entityName = "\(Location.self)"
    
    class func location(latitude: Double, longitude: Double) -> Location {
        let location: Location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
        location.latitude = latitude
        location.longitude = longitude
        return location
    }
}

extension Location {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}
