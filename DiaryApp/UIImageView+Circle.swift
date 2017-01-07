//
//  UIImageView+Circle.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    var circle: UIImageView {
        let circleImageView = self
        circleImageView.layer.borderWidth = 1
        circleImageView.layer.masksToBounds = false
        circleImageView.layer.borderColor = UIColor.black.cgColor
        circleImageView.layer.cornerRadius = circleImageView.frame.height/2
        circleImageView.clipsToBounds = true
        return circleImageView
    }
}
