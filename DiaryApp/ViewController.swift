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
        let dataSource = EntryDataSource(tableView: self.tableView, results: [])
        return dataSource
    }()
    
    lazy var dataProvider: EntryDataProvider = {
        let dataProvider = EntryDataProvider(delegate: self.dataSource)
        return dataProvider
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Entry.EntryCell.self, forCellReuseIdentifier: Entry.EntryCell.reuseIdentifier)
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

        print(entries)
        
        
        self.tableView.delegate = self
        self.dataProvider.perform(request: Entry.allEntriesRequest)
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.dataSource.results)
    }
}

