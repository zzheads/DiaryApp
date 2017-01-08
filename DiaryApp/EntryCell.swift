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
    
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    class func instanceFromNib() -> EntryCell {
        return UINib(nibName: "EntryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryCell
    }
}
