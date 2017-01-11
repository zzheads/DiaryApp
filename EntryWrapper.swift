//
//  EntryWrapper.swift
//  DiaryApp
//
//  Created by Alexey Papin on 11.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

protocol EntryType {
    var text: String { get set }
    var date: Date { get set }
    var photo: UIImage? { get set }
    var location: CLLocation? { get set }
    var placemark: String? { get set }
    var mood: Mood { get set }
    
    init(text: String, date: Date, photo: UIImage?, location: CLLocation?, placemark: String?, mood: Mood)
}

class EntryWrapper: EntryType {
    var text: String
    var date: Date
    var photo: UIImage?
    var location: CLLocation?
    var placemark: String?
    var mood: Mood
    
    required init(text: String, date: Date, photo: UIImage?, location: CLLocation?, placemark: String?, mood: Mood) {
        self.text = text
        self.date = date
        self.photo = photo
        self.location = location
        self.placemark = placemark
        self.mood = mood
    }
    
    init() {
        self.text = ""
        self.date = Date()
        self.photo = nil
        self.location = nil
        self.placemark = nil
        self.mood = .Unknown
    }
    
    func setupWith(entry: EntryType) {
        self.text = entry.text
        self.date = entry.date
        self.photo = entry.photo
        self.location = entry.location
        self.placemark = entry.placemark
        self.mood = entry.mood
    }
        
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

}
