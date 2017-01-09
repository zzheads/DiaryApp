//
//  Date+StringFormat.swift
//  DiaryApp
//
//  Created by Alexey Papin on 09.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"        
        return "\(dateFormatter.string(from: self))"
    }
}
