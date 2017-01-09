//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
import CoreData
@testable import DiaryApp

class DiaryAppTests: XCTestCase {
    weak var moc: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        self.moc = CoreDataController.sharedInstance.managedObjectContext
    }
    
    override func tearDown() {
        self.moc = nil
        super.tearDown()
    }
    
    func testDatabaseReadWrite() {
        guard
        let moc = self.moc,
        let mood = Mood(title: "Happy"),
        let photo = Photo(image: #imageLiteral(resourceName: "icn_calendar")),
        let loc = Location(latitude: 1.00, longitude: 2.00),
        let entry = Entry(title: "Test_title", text: "Test_TEXT_TEXT", date: nil, photo: photo, location: loc, mood: mood)
        else {
            fatalError("moc=\(self.moc) Can not initialize!")
        }
        
        moc.reset()
        
        do {
            
            try moc.save()
            
            let savedMoods = try moc.fetch(Mood.allMoodsRequest)
            let savedLocations = try moc.fetch(Location.allLocationsRequest)
            let savedPhotos = try moc.fetch(Photo.allPhotosRequest)
            let savedEntries = try moc.fetch(Entry.allEntriesRequest)
            
            XCTAssert(savedMoods.count == 0, "Mood saved without calls moc.save!, savedMoods=\(savedMoods.count)")
            XCTAssert(savedPhotos.count == 0, "Photo saved without calls moc.save!, savedPhotos=\(savedPhotos.count)")
            XCTAssert(savedLocations.count == 0, "Location saved without calls moc.save!, savedLocations=\(savedLocations.count)")
            XCTAssert(savedEntries.count == 0, "Entry saved without calls moc.save!, savedEntries=\(savedEntries.count)")
            
            
        } catch (let error) {
            NSLog("\(error)")
        }
        
        
        XCTAssert(!entry.isInserted)
        entry.insert()
        XCTAssert(entry.isInserted)
        
    }
    
    func testDateToFormattedString() {
        let date = Date()
        let message = "FORMATTED STRING IS: \(date.formattedString)"
        NSLog(message)
        print(">>>"+message)
    }
}
