//
//  EntryDetailsView.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class EntryDetailsView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImage.makeCircle()
    }

    class func loadFromNib() -> EntryDetailsView {
        let view = UINib(nibName: "EntryDetailsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryDetailsView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
}
