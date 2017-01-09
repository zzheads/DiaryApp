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
    var results: [Entry]
    
    init(tableView: UITableView, results: [Entry]) {
        self.tableView = tableView
        self.results = results
        super.init()
        self.tableView.dataSource = self
    }
    
    func objectAt(indexPath: IndexPath) -> Entry {
        return self.results[indexPath.row]
    }
    
    func cellAt(indexPath: IndexPath) -> EntryCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
        cell.setupWith(entry: objectAt(indexPath: indexPath))
        return cell
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
        return cellAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let updates = [DataProviderUpdate<Entry>.Remove(indexPath)]
            processUpdates(updates: updates)
            tableView.setEditing(false, animated: true)
        case .insert:
            guard let newEntry = Entry(title: "", text: "", date: Date(), photo: nil, location: nil, mood: nil) else {
                return
            }
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
