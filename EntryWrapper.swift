//
//  EntryWrapper.swift
//  DiaryApp
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

protocol EntryType: class {
    var text: String { get set }
    var date: Date { get set }
    var mood: Mood { get set }
    var photo: UIImage? { get set }
    var location: CLLocation? { get set }
    var placemark: String? { get set }
    
    init(text: String, date: Date, mood: Mood, photo: UIImage?, location: CLLocation?, placemark: String?)
}

extension EntryType {
    func setPlacemark(completion: @escaping (String?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        guard let location = self.location else {
            return
        }
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let placemark = placemarks.first
                else {
                    completion(nil, error)
                    return
            }
            self.placemark = placemark.myDescription
            completion(self.placemark, nil)
        }
    }
    
    func updateWith(entry: EntryType) {
        self.text = entry.text
        self.date = entry.date
        self.mood = entry.mood
        self.photo = entry.photo
        self.location = entry.location
        self.placemark = entry.placemark
    }
}

class EntryWrapper: EntryType {
    var text: String
    var date: Date
    var mood: Mood
    var photo: UIImage?
    var location: CLLocation?
    var placemark: String? 
    
    required init(text: String = "", date: Date = Date(), mood: Mood = .Unknown, photo: UIImage? = nil, location: CLLocation? = nil, placemark: String? = nil) {
        self.text = text
        self.date = date
        self.mood = mood
        self.photo = photo
        self.location = location
        self.placemark = placemark
    }
}
