//
//  Mood.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum Mood: String {
    case Bad
    case Average
    case Happy
    case Unknown

    init(rawValue: String) {
        switch rawValue {
        case Mood.Average.rawValue: self = .Average
        case Mood.Bad.rawValue: self = .Bad
        case Mood.Happy.rawValue: self = .Happy
        default: self = .Unknown
        }
    }
    
    var badgeImage: UIImage {
        switch self {
        case .Bad: return #imageLiteral(resourceName: "icn_bad")
        case .Average: return #imageLiteral(resourceName: "icn_average")
        case .Happy: return #imageLiteral(resourceName: "icn_happy")
        default: return #imageLiteral(resourceName: "icn_noimage")
        }
    }
}
