//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Alexey Papin on 08.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

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
        cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width/2
        cell.photoImageView.layer.masksToBounds = true
        
        cell.entryTitleLabel.text = entry.title
        cell.entryTextLabel.text = entry.text
        cell.photoImageView.image = entry.photo?.image
        cell.moodBadgeImageView.image = entry.mood?.badgeImage
        
        if let location = entry.location {
            cell.locationImageView.image = #imageLiteral(resourceName: "icn_geolocate")
            cell.entryLocationLabel.text = location.description
        }
        
        return cell
    }
}
