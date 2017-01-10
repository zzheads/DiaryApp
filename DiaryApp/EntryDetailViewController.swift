//
//  EntryDetailViewController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class EntryDetailsViewController: UIViewController {
    
    lazy var entryView: EntryDetailsView = {
        let view = EntryDetailsView.loadFromNib()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
