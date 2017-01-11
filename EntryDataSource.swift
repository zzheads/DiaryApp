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
    var results: [EntryType] {
        // For debug purposes only, same with self.count variable, after debug - remove it and observers
        willSet {
            self.count = self.results.count
        }
        didSet {
            if (self.results.count > self.count) {
                print("DataSource: Added \(self.results.count - self.count) entries...")
            }
            if (self.results.count < self.count) {
                print("DataSource: Removed \(self.count - self.results.count) entries...")
            }
            if (self.results.count == self.count) {
                print("DataSource: Looks like it was update...")
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
    
    func objectAt(indexPath: IndexPath) -> EntryType {
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
            let updates = [DataProviderUpdate<EntryType>.Remove(indexPath)]
            processUpdates(updates: updates)
            tableView.setEditing(false, animated: true)
        case .insert:
            let newEntry = Entry(text: "")
            let updates = [DataProviderUpdate<EntryType>.Insert(newEntry)]
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
    
    func processUpdates(updates: [DataProviderUpdate<EntryType>]) {
        var focusIndexPath = IndexPath(row: 0, section: 0)
        
        self.tableView.beginUpdates()
        
        for (index, update) in updates.enumerated() {
            switch (update) {
            case .Insert(let entry):
                self.results.insert(entry, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                focusIndexPath = indexPath
                
            case .Remove(let indexPath):
                let objectForDelete = self.results[indexPath.row]
                self.results.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                CoreDataController.sharedInstance.managedObjectContext.delete(objectForDelete as! NSManagedObject)
                focusIndexPath = indexPath
                
            case .Change(let entry, let indexPath):
                self.results[indexPath.row] = entry
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                focusIndexPath = indexPath
            }
        }

        self.tableView.endUpdates()

        self.tableView.selectRow(at: focusIndexPath, animated: true, scrollPosition: .middle)

        CoreDataController.sharedInstance.saveContext()
        print("Context saved, registered objects: \(CoreDataController.sharedInstance.managedObjectContext.registeredObjects.count)")
    }
}
