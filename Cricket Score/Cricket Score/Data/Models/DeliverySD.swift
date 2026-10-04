//
//  DeliverySD.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation
import SwiftData

// MARK: - SwiftData Model (Data Layer)
@Model
final class DeliverySD {
    // Identifiers & Sync Metadata
    @Attribute(.unique) var id: UUID
    var matchId: UUID
    var inningsId: UUID
    var createdAt: Date
    var isSynced: Bool
    
    // Match Context
    var overNumber: Int
    var ballNumber: Int
    var bowlerId: UUID
    var strikerId: UUID
    var nonStrikerId: UUID
    
    // Action & Result
    var runsOffBat: Int
    
    // Note: Since SwiftData cannot directly store complex enums with associated values,
    // we encode them as Data. Ensure DeliveryExtras and WicketEvent conform to `Codable` in your Domain layer.
    var extrasData: Data?
    var wicketData: Data?
    
    init(id: UUID, matchId: UUID, inningsId: UUID, createdAt: Date, isSynced: Bool, overNumber: Int, ballNumber: Int, bowlerId: UUID, strikerId: UUID, nonStrikerId: UUID, runsOffBat: Int, extrasData: Data? = nil, wicketData: Data? = nil) {
        self.id = id
        self.matchId = matchId
        self.inningsId = inningsId
        self.createdAt = createdAt
        self.isSynced = isSynced
        self.overNumber = overNumber
        self.ballNumber = ballNumber
        self.bowlerId = bowlerId
        self.strikerId = strikerId
        self.nonStrikerId = nonStrikerId
        self.runsOffBat = runsOffBat
        self.extrasData = extrasData
        self.wicketData = wicketData
    }
}
