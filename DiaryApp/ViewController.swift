//
//  ViewController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import CoreData

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
        tableView.estimatedRowHeight = 40
        tableView.addGestureRecognizer(self.swipeLeftGestureRecognizer)
        tableView.addGestureRecognizer(self.swipeRightGestureRecognizer)
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let photo = Photo(image: #imageLiteral(resourceName: "photo"))
        let mood = Mood(title: "Happy")
        let loc2 = Location(clLocation: LocationManager().location!) { (placemarks, error) in
            self.tableView.reloadData()
        }
        let loc1 = Location(latitude: 40.787, longitude: -74.01) { (placemarks, error) in
            self.tableView.reloadData()
        }
        
//        let entry1 = Entry(title: "Saturday, 1st January", text: "I'm thinking this may be due to images having in the filename, such as the convention. SVN uses that symbol for revision syntax (to escape it when working with SVN in the command line, you simply add an at the end as the last occurrence is the one it uses to try and determine revision info). Simply running Update worked for me. When I added some new images, I actually had to manually select on the 2x/3x variants in the File Inspector pane as well. Weird.", date: Date(), photo: photo, location: loc1, mood: mood)
//        
//        let entry2 = Entry(title: "Tuesday, 12th February", text: "I have a class called MyClass that is a subclass of UIView, that I want to initialise with a xib file. I am not sure how to initialise this class with the xib file called View.xib", date: Date(), photo: nil, location: loc2, mood: Mood(title: "Bad"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
        self.navigationItem.title = "Diary App"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add record", style: .plain, target: self, action: #selector(self.addRecord(sender:)))
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        self.tableView.delegate = self
        self.dataProvider.perform(request: Entry.allEntriesRequest)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsController = EntryDetailsController.loadFromNib(entry: self.dataSource.objectAt(indexPath: indexPath))
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
    
    func addRecord(sender: UIBarButtonItem) {
        let updates = DataProviderUpdate<Entry>.Insert(Entry.emptyInstance)
        self.dataSource.processUpdates(updates: [updates])
    }
}

