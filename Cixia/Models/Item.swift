//
//  Item.swift
//  Cixia
//
//  Created by 宋秉徽 on 2025/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
