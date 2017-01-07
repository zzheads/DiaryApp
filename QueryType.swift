//
//  QueryType.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CloudKit

enum QueryType {
    case All
}

extension QueryType {
    var query: CKQuery {
        switch self {
        case .All:
            let allPredicate = NSPredicate(value: true)
            let query = CKQuery(recordType: Entry.entityName, predicate: allPredicate)
            query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            return query
        }
    }
}
