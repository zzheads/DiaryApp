//
//  UIImageView+Circle.swift
//  DiaryApp
//
//  Created by Alexey Papin on 09.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeCircle() {
        self.layer.cornerRadius = self.bounds.size.width/2
        self.layer.masksToBounds = true
    }
}
