//
//  ViewController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController {
    
    lazy var dataSource: EntryDataSource = {
        let dataSource = EntryDataSource(tableView: self.tableView, results: [])
        return dataSource
    }()
    
    lazy var dataProvider: EntryDataProvider = {
        let dataProvider = EntryDataProvider(delegate: self.dataSource)
        return dataProvider
    }()
    
    lazy var swipeLeftGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(recognizer:)))
        recognizer.direction = .left
        return recognizer
    }()
    
    lazy var swipeRightGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(recognizer:)))
        recognizer.direction = .right
        return recognizer
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
        tableView.addGestureRecognizer(self.swipeLeftGestureRecognizer)
        tableView.addGestureRecognizer(self.swipeRightGestureRecognizer)
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.dataProvider.perform(request: Entry.allEntriesRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
        self.navigationItem.title = "Diary App"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.sort(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addRecord(sender:)))
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.dataSource.objectAt(indexPath: indexPath)
        let detailsController = EntryDetailsController.loadFromNib(entry: entry, indexPath: indexPath)
        detailsController.delegate = self
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard
            let cell = tableView.cellForRow(at: indexPath)
            else {
            return .none
        }
        if cell.isEditing {
            return .delete
        }
        return .none
    }
}

extension ViewController {
    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        let location = recognizer.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            return
        }
        let cell = self.tableView.cellForRow(at: indexPath)
        switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirection.right:
            cell?.setEditing(true, animated: true)
            self.tableView.setEditing(true, animated: true)

        case UISwipeGestureRecognizerDirection.left:
            cell?.setEditing(false, animated: true)
            self.tableView.setEditing(false, animated: true)
            
        default:
            break
        }
    }
    
    func sort(sender: UIBarButtonItem) {
        let updates = DataProviderUpdate<EntryType>.SortByDate
        self.dataSource.processUpdates(updates: [updates])
    }
    
    func addRecord(sender: UIBarButtonItem) {
        let updates = DataProviderUpdate<EntryType>.Insert(Entry())
        self.dataSource.processUpdates(updates: [updates])
    }
}

extension ViewController: EntryDetailsControllerDelegate {
    func entryDetailsController(didFinishModifyEntry entryWrapper: EntryWrapper, at indexPath: IndexPath) {
        let update = DataProviderUpdate<EntryType>.Change(entryWrapper, indexPath)
        self.dataSource.processUpdates(updates: [update])
    }
}

