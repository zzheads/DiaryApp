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

        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])

        
        let moc = CoreDataController.sharedInstance.managedObjectContext
        
//        let loc = Location(latitude: 99.99, longitude: 88.88)
//        let mood = Mood(title: "Happy")
//        let photo = Photo(image: #imageLiteral(resourceName: "icn_write_post"))
//        let entry2 = Entry(title: "OTHER_TITLE", text: "TEST_text_text_text_text_text", date: nil, photo: photo, location: loc, mood: mood)
//        
//        try! moc.save()
        
        let request = Photo.allPhotosRequest
        
        do {
            let objects = try moc.fetch(request) as! [Photo]
            for object in objects {
                print("Obj: \(object)")
                moc.delete(object)
            }
        } catch (let error) {
            print(error)
        }

        try! moc.save()
        
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

