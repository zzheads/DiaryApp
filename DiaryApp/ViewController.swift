//
//  ViewController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var dataSource: EntryDataSource = {
        let dataSource = EntryDataSource(fetchRequest: Entry.allEntriesRequest, tableView: self.tableView)
        return dataSource
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        let mood = Mood.mood(withTitle: "Bad")
        let location = Location.location(latitude: 10.0, longitude: 20.0)
        let photo = Photo.photo(withImage: UIImage(named: "icn_bad"))
        
        let entries = [
            Entry.entry(withTitle: "Test entry1", text: "Some not long text of test entry", photo: photo, location: location, mood: mood),
            Entry.entry(withTitle: "Test entry2", text: "Some not long text of test entry", photo: photo, location: location, mood: mood),
            Entry.entry(withTitle: "Test entry3", text: "Some not long text of test entry", photo: photo, location: location, mood: mood),
            Entry.entry(withTitle: "Test entry4", text: "Some not long text of test entry", photo: photo, location: location, mood: mood),
            Entry.entry(withTitle: "Test entry5", text: "Some not long text of test entry", photo: photo, location: location, mood: mood)
        ]

        let results = entries.flatMap { print("\($0.title)") }
        print(results)
        
        self.tableView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

