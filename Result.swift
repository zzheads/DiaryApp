//
//  Result.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Failure(Error)
}
