//
//  Photo.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Photo)
class Photo: NSManagedObject {
    static let entityName = "\(Photo.self)"
    
    convenience init?(image: UIImage) {
        let context = CoreDataController.sharedInstance.managedObjectContext
        guard
        let entity = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context),
        let data = UIImageJPEGRepresentation(image, 1.0)
        else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
        self.data = data
    }
    
    class func photo(withImage image: UIImage?) -> Photo? {
        guard
            let image = image,
            let data = UIImageJPEGRepresentation(image, 1.0) else {
            return nil
        }
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        photo.data = data
        return photo
    }
    
    static let allPhotosRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Photo.entityName)
        return request
    }()
}

extension Photo {
    @NSManaged var data: Data
}

extension Photo {
    var image: UIImage {
        if let image = UIImage(data: self.data) {
            return image
        }
        return #imageLiteral(resourceName: "icn_picture")
    }
}
