//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
@testable import DiaryApp

class DiaryAppTests: XCTestCase {
    var mood = Mood.mood(withTitle: "Happy")

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssertNotNil(self.mood)
    }
}
