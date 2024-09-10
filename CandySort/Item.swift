//
//  Item.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
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
