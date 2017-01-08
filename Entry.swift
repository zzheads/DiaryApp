//
//  Entry.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
class Entry: NSManagedObject {
    static let entityName = "\(Entry.self)"
    
    convenience init?(title: String, text: String, date: Date?, photo: Photo?, location: Location?, mood: Mood?) {
        let context = CoreDataController.sharedInstance.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: Entry.entityName, in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.text = text
        if let date = date {
            self.date = date
        } else {
            self.date = Date()
        }
        self.photo = photo
        self.location = location
        self.mood = mood
    }
    
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
    
    public func insert() {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        if (moc.registeredObject(for: self.objectID) == nil) {
            moc.insert(self)
        }
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

extension Entry {
    var photoWithMood: UIImageView {
        var image: UIImage
        var moodImage: UIImage
        
        if let photo = self.photo {
            image = photo.image
        } else {
            image = #imageLiteral(resourceName: "icn_picture")
        }
        let imageView = UIImageView(image: image.makeSquare()).circle
        
        if let mood = self.mood {
            moodImage = mood.badgeImage
        } else {
            moodImage = #imageLiteral(resourceName: "icn_noimage")
        }
        let moodView = UIImageView(image: moodImage)
        
        let center = CGPoint(x: imageView.bounds.size.width*3/4, y: imageView.bounds.size.height*3/4)
        moodView.center = center
        imageView.addSubview(moodView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
}

extension Entry {
    var debugInfo: String {
        return "Entry: id=\(self.objectID) title=\(self.title) text=\(self.text) date=\(self.date) photo=\(self.photo) location=\(self.location) mood=\(self.mood)"
    }
}

extension Entry {
    var cell: EntryCell {
        let cell = EntryCell.instanceFromNib()
        cell.photoView = self.photoWithMood
        cell.titleLabel.text = self.title
        cell.entryLabel.text = self.text
        return cell
    }
}





























