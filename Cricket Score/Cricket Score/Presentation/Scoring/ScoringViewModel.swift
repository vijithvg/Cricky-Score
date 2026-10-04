//
//  ScoringViewModel.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation
import Observation

// MARK: - Presentation Layer (ViewModel)
@Observable
@MainActor
final class ScoringViewModel {
    // MARK: Dependencies
    private let recordDeliveryUseCase: RecordDeliveryUseCaseProtocol
    
    // MARK: Match Identifiers
    let matchId: UUID
    let inningsId: UUID
    
    // MARK: Active Match State (Observed by SwiftUI)
    var totalRuns: Int = 0
    var wickets: Int = 0
    var overNumber: Int = 0
    var ballNumber: Int = 0 // Tracks legal deliveries (0 to 5)
    var errorMessage: String?
    
    // MARK: Active Player IDs
    var strikerId: UUID
    var nonStrikerId: UUID
    var bowlerId: UUID
    
    // MARK: Initialization
    init(
        matchId: UUID,
        inningsId: UUID,
        strikerId: UUID,
        nonStrikerId: UUID,
        bowlerId: UUID,
        recordDeliveryUseCase: RecordDeliveryUseCaseProtocol
    ) {
        self.matchId = matchId
        self.inningsId = inningsId
        self.strikerId = strikerId
        self.nonStrikerId = nonStrikerId
        self.bowlerId = bowlerId
        self.recordDeliveryUseCase = recordDeliveryUseCase
    }
    
    // MARK: - User Intent Actions
    func logDelivery(runsOffBat: Int, extras: DeliveryExtras? = nil, wicket: WicketEvent? = nil) async {
        let request = RecordDeliveryRequest(
            matchId: matchId,
            inningsId: inningsId,
            overNumber: overNumber,
            ballNumber: ballNumber + 1, // The current ball being bowled
            bowlerId: bowlerId,
            strikerId: strikerId,
            nonStrikerId: nonStrikerId,
            runsOffBat: runsOffBat,
            extras: extras,
            wicket: wicket
        )
        
        do {
            // Execute business logic through the Domain layer
            let delivery = try await recordDeliveryUseCase.execute(request: request)
            
            // Update the UI state upon successful save
            processDeliveryResult(delivery)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Local State Management
    private func processDeliveryResult(_ delivery: Delivery) {
        // 1. Update Score
        totalRuns += delivery.totalRuns
        
        // 2. Update Wickets
        if delivery.wicket != nil {
            wickets += 1
        }
        
        // 3. Update Overs and Balls
        if delivery.isLegalDelivery {
            ballNumber += 1
            if ballNumber == 6 {
                overNumber += 1
                ballNumber = 0
            }
        }
        
        // 4. Strike Rotation Logic
        let isOddRuns = delivery.runsOffBat % 2 != 0
        let isOverComplete = ballNumber == 0 && delivery.isLegalDelivery
        
        // Strike rotates if runs are odd OR it's the end of the over.
        // It rotates TWICE (putting it back to the original striker) if both happen.
        if isOddRuns { swapBatsmen() }
        if isOverComplete { swapBatsmen() }
    }
    
    private func swapBatsmen() {
        let temp = strikerId
        strikerId = nonStrikerId
        nonStrikerId = temp
    }
}
