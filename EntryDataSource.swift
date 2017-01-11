//
//  EntryDataSource.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryDataSource: NSObject {
    let tableView: UITableView

    var count: Int
    var results: [Entry] {
        // For debug purposes only, same with self.count variable, after debug - remove it and observers
        willSet {
            self.count = self.results.count
        }
        didSet {
            if (self.results.count > self.count) {
                print("Added \(self.results.count - self.count) entries")
            }
            if (self.results.count < self.count) {
                print("Removed \(self.count - self.results.count) entries")
            }
            if (self.results.count == self.count) {
                print("Strange, results changed but count is the same")
            }
        }
    }
    
    init(tableView: UITableView, results: [Entry]) {
        self.tableView = tableView
        self.results = results
        self.count = 0
        super.init()
        self.tableView.dataSource = self
    }
    
    func objectAt(indexPath: IndexPath) -> Entry {
        return self.results[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension EntryDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
        cell.setupWith(entry: objectAt(indexPath: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let updates = [DataProviderUpdate<Entry>.Remove(indexPath)]
            processUpdates(updates: updates)
            tableView.setEditing(false, animated: true)
        case .insert:
            let newEntry = Entry(title: "", text: "", date: Date(), photo: nil, location: nil, mood: .Unknown)
            let updates = [DataProviderUpdate<Entry>.Insert(newEntry)]
            processUpdates(updates: updates)
            tableView.setEditing(false, animated: true)
        case .none:
            return
        }
    }
}

extension EntryDataSource: DataProviderDelegate {
    func providerFailedWithError(error: Error) {
        print("Provider failed with error: \(error)")
    }
    
    func processUpdates(updates: [DataProviderUpdate<Entry>]) {
        self.tableView.beginUpdates()
        
        for (index, update) in updates.enumerated() {
            switch (update) {
            case .Insert(let entry):
                self.results.insert(entry, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            case .Remove(let indexPath):
                self.results.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case .Change(let entry, let indexPath):
                self.results[indexPath.row] = entry
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        self.tableView.endUpdates()
    }
}
