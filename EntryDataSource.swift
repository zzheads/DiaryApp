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
}

// MARK: - UICollectionViewDataSource

extension EntryDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: Entry.EntryCell.reuseIdentifier, for: indexPath)
        let entry = objectAt(indexPath: indexPath)
        return entry.cell
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
            case .Insert(let memo):
                self.results.insert(memo, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        self.tableView.endUpdates()
    }
}
