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
    
    func save() {
        try! CoreDataController.sharedInstance.managedObjectContext.save()
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
        var moodBadge: UIImage
        
        if let photo = self.photo {
            image = photo.image
        } else {
            image = #imageLiteral(resourceName: "icn_picture")
        }
        let imageView = UIImageView(image: image).circle
        
        if let mood = self.mood {
            moodBadge = mood.badge
        } else {
            moodBadge = #imageLiteral(resourceName: "icn_noimage")
        }
        let moodView = UIImageView(image: moodBadge).circle
        
        imageView.addSubview(moodView)
        return imageView
    }
}

extension Entry {
    class EntryCell: UITableViewCell {
    static let reuseIdentifier = "\(EntryCell.self)"
    
    override func layoutSubviews() {
        guard let imageView = self.imageView else {
            return
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: self.bounds.size.width/6)
            ])
        
        guard let textLabel = self.textLabel else {
            return
        }
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor),
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
            ])
        }
    }
}
