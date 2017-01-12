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
    var persistenceStore: NSPersistentStore!
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    
    var dataController = CoreDataController.sharedInstance
    var fakeEntry: Entry!
    
    override func setUp() {
        super.setUp()
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistenceStore = storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = storeCoordinator
        } catch {
            print("Unresolved error: \(error)")
        }
        
        dataController.managedObjectContext = managedObjectContext
        
        fakeEntry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: managedObjectContext) as! Entry
        fakeEntry.text = "ABC"
        fakeEntry.date = Date()
        fakeEntry.mood = .Unknown
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Unresolved error: \(error)")
        }
    }
    
    override func tearDown() {
        dataController.deleteAllEntries()
        managedObjectModel = nil
        managedObjectContext = nil
        persistenceStore = nil
        storeCoordinator = nil
        super.tearDown()
    }
    
    func testGetAllEntries() {
        let allEntries = dataController.getAllEntries()
        XCTAssert(allEntries.count == 1, "More or less than 1 entry found")
    }
    
    func testDeleteAllEntries() {
        XCTAssert(dataController.getAllEntries().count == 1, "More or less than 1 entry found")
        dataController.deleteAllEntries()
        XCTAssert(dataController.getAllEntries().count == 0, "Delete failed, more than 0 entries found")
    }
    
    
    func testDateToFormattedString() {
        let date = Date()
        let message = "FORMATTED STRING IS: \(date.formattedString)"
        NSLog(message)
        print(">>>"+message)
    }
}
