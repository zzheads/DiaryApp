//
//  Entry.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData

@objc(Entry)
class Entry: NSManagedObject {
    static let entityName = "\(Entry.self)"
    
    class func entry(withTitle title: String, text: String, photo: Photo?, location: Location?, mood: Mood?) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Entry
        entry.title = title
        entry.text = text
        entry.date = Date()
        entry.photo = photo
        entry.location = location
        entry.mood = mood
        return entry
    }
    
    static var allEntriesRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }()
}

extension Entry {
    @NSManaged var title: String
    @NSManaged var text: String
    @NSManaged var date: Date
    @NSManaged var photo: Photo?
    @NSManaged var location: Location?
    @NSManaged var mood: Mood?
}
