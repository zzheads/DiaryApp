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
    let dataController = CoreDataController.sharedInstance

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
                self.results.insert(entry as! Entry, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                focusIndexPath = indexPath
                
            case .Remove(let indexPath):
                self.results.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                focusIndexPath = indexPath
                
            case .Change(let entryWrapper, let indexPath):
                self.results[indexPath.row].updateWith(entry: entryWrapper)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                focusIndexPath = indexPath
                
            case .SortByDate:
                self.results.sort(by: { (leftEntry, rightEntry) -> Bool in
                    return (leftEntry.date < rightEntry.date)
                })
                self.tableView.reloadData()
            }
        }

        self.tableView.endUpdates()

        if (tableView.cellForRow(at: focusIndexPath) != nil) {
            self.tableView.selectRow(at: focusIndexPath, animated: true, scrollPosition: .middle)
        }
        self.dataController.saveContext()
        print("Context saved, registered objects: \(CoreDataController.sharedInstance.managedObjectContext.registeredObjects.count)")
    }
}
