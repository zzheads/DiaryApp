//
//  DataProviderTests.swift
//  DiaryApp
//
//  Created by Alexey Papin on 12.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
@testable import DiaryApp

class DataProviderTests: XCTestCase {
    var dataSource: EntryDataSource!
    var tableView: UITableView!
    var dataProvider: EntryDataProvider!
    var testEntry: Entry!
    
    override func setUp() {
        super.setUp()
        tableView = UITableView()
        dataSource = EntryDataSource(tableView: tableView, results: [])
        dataProvider = EntryDataProvider(delegate: dataSource)
        testEntry = Entry(text: "Test entry")
    }
    
    override func tearDown() {
        tableView = nil
        dataSource = nil
        dataProvider = nil
        testEntry = nil
        super.tearDown()
    }
    
    func testInsert() {
        XCTAssert(dataSource.results.count == 0, "More than 0 results already in data source")
        let update = DataProviderUpdate<EntryType>.Insert(testEntry)
        dataSource.processUpdates(updates: [update])
        XCTAssert(dataSource.results.count == 1, "")
    }
    
    func testDelete() {
        var update = DataProviderUpdate<EntryType>.Insert(testEntry)
        dataSource.processUpdates(updates: [update])
        XCTAssert(dataSource.results.count == 1, "")
        let indexPath = IndexPath(row: 0, section: 0)
        update = DataProviderUpdate<EntryType>.Remove(indexPath)
        dataSource.processUpdates(updates: [update])
        XCTAssert(dataSource.results.count == 0, "Delete failed, more than 0 results already in data source")
    }
    
    func testChange() {
        var update = DataProviderUpdate<EntryType>.Insert(testEntry)
        dataSource.processUpdates(updates: [update])
        XCTAssert(dataSource.results.count == 1, "")
        XCTAssert(dataSource.results[0].text == "Test entry", "Found entry with some unexpected text: \(dataSource.results[0].text)")

        let indexPath = IndexPath(row: 0, section: 0)
        let entryWrapper = EntryWrapper(text: "New text!")
        update = DataProviderUpdate<EntryType>.Change(entryWrapper, indexPath)
        dataSource.processUpdates(updates: [update])
        XCTAssert(dataSource.results[0].text == "New text!", "Found entry with some unexpected text: \(dataSource.results[0].text)")
    }
}
