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
