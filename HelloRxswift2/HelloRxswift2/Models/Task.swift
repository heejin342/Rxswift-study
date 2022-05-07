//
//  Task.swift
//  HelloRxswift2
//
//  Created by 김희진 on 2022/03/26.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
