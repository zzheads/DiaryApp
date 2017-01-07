//
//  Mood.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData

class Mood: NSManagedObject {
    static let entityName = "\(Mood.self)"
    
    class func mood(withTitle title: String) -> Mood {
        let mood: Mood = NSEntityDescription.insertNewObject(forEntityName: Mood.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Mood
        mood.title = title
        return mood
    }
}

extension Mood {
    @NSManaged var title: String
}

extension Mood {
    override var description: String {
        return "Mood: \(self.title)"
    }
}
