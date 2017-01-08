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
    
    convenience init?(latitude: Double, longitude: Double) {
        let context = CoreDataController.sharedInstance.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
        self.latitude = latitude
        self.longitude = longitude
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
}
