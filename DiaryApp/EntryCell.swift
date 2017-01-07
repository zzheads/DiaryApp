//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class EntryCell: UITableViewCell {
    static let reuseIdentifier = "\(EntryCell.self)"
    
    override func layoutSubviews() {
        guard let textLabel = self.textLabel else {
            return
        }
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
            ])
    }
}
