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
        photo.image = data
        return photo
    }
}

extension Photo {
    @NSManaged var image: Data
}

extension Photo {
    var imageView: UIImageView {
        let imageView = UIImageView(image: UIImage(data: self.image))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
