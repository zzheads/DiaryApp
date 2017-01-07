//
//  EntryFetchedResultsController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import CoreData
import UIKit

class EntryFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    let tableView: UITableView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error {
            print("Unresolved error \(error.localizedDescription)")
        }
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        fetchRequest.predicate = predicate
        executeFetch()
    }
    
    // MARK - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
