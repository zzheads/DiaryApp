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
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
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
        
        let entry0 = Entry(title: "Bla Bla Bla", text: "Record your thoughts for today", date: Date(), photo: nil, location: nil, mood: nil)
        let entry1 = Entry(title: "Saturday, 1st January", text: "I'm thinking this may be due to images having in the filename, such as the convention. SVN uses that symbol for revision syntax (to escape it when working with SVN in the command line, you simply add an at the end as the last occurrence is the one it uses to try and determine revision info). Simply running Update worked for me. When I added some new images, I actually had to manually select on the 2x/3x variants in the File Inspector pane as well. Weird.", date: Date(), photo: photo, location: loc1, mood: mood)
        
        let entry2 = Entry(title: "Tuesday, 12th February", text: "I have a class called MyClass that is a subclass of UIView, that I want to initialise with a xib file. I am not sure how to initialise this class with the xib file called View.xib", date: Date(), photo: nil, location: loc2, mood: Mood(title: "Bad"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        self.tableView.delegate = self
        self.dataProvider.perform(request: Entry.allEntriesRequest)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let placemark = self.dataSource.results[indexPath.row].location?.placemark {
            print("Placemark: \(placemark)")
        } else {
            print("There is no placemark")
        }
    }
}

