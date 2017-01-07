//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest

class DiaryAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let mood = Mood.mood(withTitle: "Bad")
        XCTAssertNotNil(mood)
    }    
}
