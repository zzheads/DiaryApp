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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Entry.EntryCell.self, forCellReuseIdentifier: Entry.EntryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photo = Photo(image: #imageLiteral(resourceName: "photo"))
        let mood = Mood(title: "Unknown")
        let entry = Entry(title: "Test", text: "Text", date: Date(), photo: photo, location: nil, mood: mood)
        let imageView = entry?.photoWithMood
        imageView?.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(imageView!)
        NSLayoutConstraint.activate([
            imageView!.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            imageView!.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            ])
        
//        self.view.addSubview(self.tableView)
//        NSLayoutConstraint.activate([
//            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
//            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
//            ])
        
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

