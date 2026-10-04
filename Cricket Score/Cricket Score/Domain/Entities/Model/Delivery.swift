//
//  Delivery.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation

// MARK: - Wicket Event
struct WicketEvent: Codable {
    enum WicketType: Codable {
        case bowled
        case caught
        case lbw
        case runOut
        case stumped
        case hitWicket
        case retiredHurt
    }
    
    let type: WicketType
    let dismissedPlayerId: UUID
    let fielderId: UUID?
}

// MARK: - Delivery Entity
struct Delivery: Identifiable {
    // Identifiers & Sync Metadata
    let id: UUID
    let matchId: UUID
    let inningsId: UUID
    let createdAt: Date
    var isSynced: Bool
    
    // Match Context
    let overNumber: Int
    let ballNumber: Int
    let bowlerId: UUID
    let strikerId: UUID
    let nonStrikerId: UUID
    
    // Action & Result
    let runsOffBat: Int
    let extras: DeliveryExtras?
    let wicket: WicketEvent?
    
    // Computed Properties for Domain Logic
    var isLegalDelivery: Bool {
        if let extras = extras {
            switch extras {
            case .wide, .noBall: return false
            default: return true
            }
        }
        return true
    }
    
    var totalRuns: Int {
        let extraRuns = extras?.runValue ?? 0
        return runsOffBat + extraRuns
    }
}
