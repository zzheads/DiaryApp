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
    
    class func promptingInstance() -> EntryCell {
        let cell = UINib(nibName: "EntryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryCell
        cell.photoImageView.makeCircle()
        cell.textLabel?.text = "Record your thoughts for today"
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImageView.makeCircle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(entry: Entry) {
        let mirror = Mirror(reflecting: entry)
        print("Class of object - \(mirror), \(entry.debugInfo), \(entry.date)")
        self.entryTitleLabel.text = entry.date.formattedString
        self.entryTextLabel.text = entry.text
        if let photo = entry.photo {
            self.photoImageView.image = photo.image
        } else {
            self.photoImageView.image = #imageLiteral(resourceName: "icn_picture")
        }
        if let mood = entry.mood {
            self.moodBadgeImageView.image = mood.badgeImage
        } else {
            self.moodBadgeImageView.image = #imageLiteral(resourceName: "icn_noimage")
        }
        
        if let location = entry.location {
            self.locationImageView.image = #imageLiteral(resourceName: "icn_geolocate")
            self.entryLocationLabel.text = location.placemark
        }
    }
}
