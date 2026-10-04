//
//  Item.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
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
