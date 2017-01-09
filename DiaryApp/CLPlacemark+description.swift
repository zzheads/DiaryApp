//
//  CLPlacemark+description.swift
//  DiaryApp
//
//  Created by Alexey Papin on 09.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var myDescription: String {
        var desc = ""
        if let name = self.name {
            desc += name + ", "
        } else {
            desc += "Unknown name, "
        }
        
        if let locality = self.locality {
            desc += locality + " "
        } else {
            desc += "Unknown city "
        }
        
        if let administrativeArea = self.administrativeArea {
            desc += "(\(administrativeArea)) - "
        } else {
            desc += "() - "
        }
        
        if let country = self.isoCountryCode {
            desc += country
        } else {
            desc += "##"
        }
        return desc
    }
}
