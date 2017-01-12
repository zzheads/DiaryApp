//
//  Entry.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UIKit

@objc(Entry)
class Entry: NSManagedObject, EntryType {
    static let entityName = "\(Entry.self)"
    static let emptyTextPlaceholder = "Record your thoughts for today"
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required convenience init(text: String = "", date: Date = Date(), mood: Mood = .Unknown, photo: UIImage? = nil, location: CLLocation? = nil, placemark: String? = nil) {
        let context = CoreDataController.sharedInstance.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: Entry.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.text = text
        self.date = date
        self.mood = mood
        self.photo = photo
        self.location = location
        self.placemark = placemark
    }
        
    public func insert() {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        if (moc.registeredObject(for: self.objectID) == nil) {
            moc.insert(self)
        }
    }
    
    static let allEntriesRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }()
    
    class func entriesWithTitle(title: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        let predicate = NSPredicate(format: "title = %@", title)
        request.predicate = predicate
        return request
    }
}

extension Entry {
    @NSManaged var text: String
    @NSManaged var date: Date
    
    @NSManaged private var moodValue: String
    public var mood: Mood {
        get {
            return Mood(rawValue: self.moodValue)
        }
        set {
            self.moodValue = newValue.rawValue
        }
    }
    
    @NSManaged private var photoData: Data?
    public var photo: UIImage? {
        get {
            guard
                let data = self.photoData,
                let image = UIImage(data: data)
                else {
                return #imageLiteral(resourceName: "icn_picture")
            }
            return image
        }
        set {
            guard let newValue = newValue else {
                self.photoData = nil
                return
            }
            self.photoData = UIImageJPEGRepresentation(newValue, 0.0)
        }
    }
    
    @NSManaged private var latitude: Double
    @NSManaged private var longitude: Double
    public var location: CLLocation? {
        get {
            if ((!self.longitude.isNaN) && (!self.latitude.isNaN)) {
                return CLLocation(latitude: self.latitude, longitude: self.longitude)
            }
            return nil
        }
        set {
            guard let newValue = newValue else {
                self.latitude = Double.nan
                self.longitude = Double.nan
                return
            }
            self.latitude = newValue.coordinate.latitude
            self.longitude = newValue.coordinate.longitude
        }
    }
    
    @NSManaged var placemark: String?
}

extension Entry {
    var debugInfo: String {
        return "Entry: id=\(self.objectID) text=\(self.text) date=\(self.date) photo=\(self.photo) location=\(self.location) mood=\(self.mood)"
    }
}
























