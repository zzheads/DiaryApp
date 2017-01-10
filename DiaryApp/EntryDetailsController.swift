//
//  EntryDetailsController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class EntryDetailsController: UIViewController {
    static let nibName = "\(EntryDetailsController.self)"
    var entry: Entry? = nil
    
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var averageButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodBadgeView: UIImageView!
    @IBOutlet weak var locationView: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    
    class func loadFromNib(entry: Entry) -> EntryDetailsController{
        let controller = UINib(nibName: EntryDetailsController.nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryDetailsController
        controller.setupWith(entry: entry)
        return controller
    }
    
    func setupWith(entry: Entry) {
        self.entry = entry
        if let photo = entry.photo {
            self.photoImage.image = photo.image
        } else {
            self.photoImage.image = #imageLiteral(resourceName: "icn_picture")
        }
        if let mood = entry.mood {
            self.moodBadgeView.image = mood.badgeImage
        } else {
            self.moodBadgeView.image = #imageLiteral(resourceName: "icn_noimage")
        }
        if let location = entry.location {
            self.locationButton.setTitle(location.placemark, for: .normal)
        } else {
            self.locationButton.setTitle("Add location", for: .normal)
        }
        self.titleLabel.text = entry.date.formattedString
        self.textView.text = entry.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImage.makeCircle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Diary Entry Details"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelEntryDetails(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveEntryDetails(sender:)))

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension EntryDetailsController {
    func saveEntryDetails(sender: UIBarButtonItem) {
        
    }
    
    func cancelEntryDetails(sender: UIBarButtonItem) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
