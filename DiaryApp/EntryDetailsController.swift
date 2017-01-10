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
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    class func loadFromNib(entry: Entry) -> EntryDetailsController{
        let controller = UINib(nibName: EntryDetailsController.nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryDetailsController
        if let photo = entry.photo {
            controller.photoImage.image = photo.image
        } else {
            controller.photoImage.image = #imageLiteral(resourceName: "icn_picture")
        }
        controller.titleLabel.text = entry.date.formattedString
        controller.textView.text = entry.text
        return controller
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImage.makeCircle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
