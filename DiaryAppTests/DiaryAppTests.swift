//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
@testable import DiaryApp

class DiaryAppTests: XCTestCase {
    let moc = CoreDataController.sharedInstance.managedObjectContext
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        do {
            let entries = try self.moc.fetch(Entry.allEntriesRequest) as! [Entry]
            for entry in entries {
                NSLog("Entry: \(entry)")
                self.moc.delete(entry)
            }
        } catch (let error) {
            NSLog("\(error)")
        }
    }
}
