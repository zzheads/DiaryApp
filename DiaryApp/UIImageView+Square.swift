//
//  UIImageView+Square.swift
//  DiaryApp
//
//  Created by Alexey Papin on 08.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    // crop square image to size of standart badge and multiplier
    static let scaleTo = #imageLiteral(resourceName: "icn_happy").size.width*2.5
    
    func makeSquare() -> UIImage? {
        guard
        let cgImage = self.cgImage
        else {
            return nil
        }
        
        var refWidth = cgImage.width
        var refHeight = cgImage.height
        var x: Int
        var y: Int

        if (refWidth == refHeight) {
            return self
        }
        if (refWidth > refHeight) {
            y = 0
            x = (refWidth - refHeight) / 2
            refWidth = refHeight
        } else {
            x = 0
            y = (refHeight - refWidth) / 2
            refHeight = refWidth
        }
        let cropSquareRect = CGRect(x: x, y: y, width: refWidth, height: refHeight)
        guard let image = cgImage.cropping(to: cropSquareRect) else {
            return nil
        }
        let croppedToSquare = UIImage(cgImage: image, scale: CGFloat(refWidth)/UIImage.scaleTo, orientation: self.imageOrientation)
        return croppedToSquare
    }
}
