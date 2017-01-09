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
    
    class func instanceFromNib(entry: Entry) -> EntryCell {
        let cell = UINib(nibName: "EntryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryCell
        cell.photoImageView.makeCircle()
        
        cell.entryTitleLabel.text = entry.date.formattedString
        cell.entryTextLabel.text = entry.text
        if let photo = entry.photo {
            cell.photoImageView.image = photo.image
        } else {
            cell.photoImageView.image = #imageLiteral(resourceName: "icn_picture")
        }
        if let mood = entry.mood {
            cell.moodBadgeImageView.image = mood.badgeImage
        } else {
            cell.moodBadgeImageView.image = #imageLiteral(resourceName: "icn_noimage")
        }
        
        if let location = entry.location {
            cell.locationImageView.image = #imageLiteral(resourceName: "icn_geolocate")
            cell.entryLocationLabel.text = location.placemark
        }
        
        return cell
    }
}
