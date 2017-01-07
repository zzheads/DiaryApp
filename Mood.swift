//
//  Mood.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Mood)
class Mood: NSManagedObject {
    static let entityName = "\(Mood.self)"
 
    fileprivate enum MoodState: String {
        case Bad
        case Average
        case Happy
        case Unknown
    }
    
    class func mood(withTitle title: String) -> Mood {
        let mood: Mood = NSEntityDescription.insertNewObject(forEntityName: Mood.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Mood
        if let moodState = MoodState(rawValue: title) {
            mood.title = moodState.rawValue
        } else {
            mood.title = MoodState.Unknown.rawValue
        }
        return mood
    }
}

extension Mood {
    @NSManaged var title: String
}

extension Mood {
    var badge: UIImage {
        guard let moodState = MoodState(rawValue: self.title) else {
            return #imageLiteral(resourceName: "icn_noimage")
        }
        switch moodState {
        case .Bad: return #imageLiteral(resourceName: "icn_bad")
        case .Average: return #imageLiteral(resourceName: "icn_average")
        case .Happy: return #imageLiteral(resourceName: "icn_happy")
        default: return #imageLiteral(resourceName: "icn_noimage")
        }
    }
}
