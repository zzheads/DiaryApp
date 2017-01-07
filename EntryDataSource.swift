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
    let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    let fetchedResultsController: EntryFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView) {
        self.tableView = tableView
        self.fetchedResultsController = EntryFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, tableView: tableView)
        super.init()
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        self.fetchedResultsController.performFetch(withPredicate: predicate)
        self.tableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension EntryDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath)
        let entry = fetchedResultsController.object(at: indexPath) as! Entry
        //cell.imageView?.image = entry.photo?.imageView.image
        cell.textLabel?.text = entry.title
        return cell
    }
}
