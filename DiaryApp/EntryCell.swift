//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Alexey Papin on 08.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class EntryCell: UITableViewCell {
    static let reuseIdentifier = "\(EntryCell.self)"

    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var moodBadgeImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var entryLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImageView.makeCircle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(entry: Entry) {
        self.entryTitleLabel.text = entry.date.formattedString
        
        if (!entry.text.isEmpty) {
            self.entryTextLabel.text = entry.text
        } else {
            self.entryTextLabel.text = Entry.emptyTextPlaceholder
            self.entryTextLabel.textColor = .lightGray
        }

        self.photoImageView.image = entry.photo
        self.moodBadgeImageView.image = entry.mood.badgeImage
        
        if (entry.location != nil) {
            self.locationImageView.image = #imageLiteral(resourceName: "icn_geolocate")
            self.entryLocationLabel.text = entry.placemark
        } else {
            self.locationImageView.image = nil
        }
    }
}
