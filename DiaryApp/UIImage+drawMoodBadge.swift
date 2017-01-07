//
//  UIImage+drawMoodBadge.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageWith(moodBadge: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        moodBadge.draw(in: CGRect(x: 0, y: self.size.height - moodBadge.size.height, width: moodBadge.size.width, height: moodBadge.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
