//
//  RecordDeliveryUseCase.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation

// MARK: - Use Case Request DTO
struct RecordDeliveryRequest {
    let matchId: UUID
    let inningsId: UUID
    let overNumber: Int
    let ballNumber: Int
    let bowlerId: UUID
    let strikerId: UUID
    let nonStrikerId: UUID
    let runsOffBat: Int
    let extras: DeliveryExtras?
    let wicket: WicketEvent?
}

// MARK: - Use Case Protocol
protocol RecordDeliveryUseCaseProtocol {
    func execute(request: RecordDeliveryRequest) async throws -> Delivery
}

// MARK: - Use Case Implementation
final class RecordDeliveryUseCase: RecordDeliveryUseCaseProtocol {
    private let repository: MatchRepository
    
    // Dependency Injection ensures the Domain layer doesn't know about SwiftData
    init(repository: MatchRepository) {
        self.repository = repository
    }
    
    func execute(request: RecordDeliveryRequest) async throws -> Delivery {
        // 1. Business Rule Validation
        guard request.runsOffBat >= 0 && request.runsOffBat <= 6 else {
            throw NSError(
                domain: "DomainError",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "Runs off bat must be between 0 and 6."]
            )
        }
        
        // 2. Entity Construction
        let delivery = Delivery(
            id: UUID(),
            matchId: request.matchId,
            inningsId: request.inningsId,
            createdAt: Date(),
            isSynced: false,
            overNumber: request.overNumber,
            ballNumber: request.ballNumber,
            bowlerId: request.bowlerId,
            strikerId: request.strikerId,
            nonStrikerId: request.nonStrikerId,
            runsOffBat: request.runsOffBat,
            extras: request.extras,
            wicket: request.wicket
        )
        
        // 3. Persistence via Protocol Boundary
        try await repository.saveDelivery(delivery)
        
        // 4. Return the processed entity so the ViewModel can update the UI
        return delivery
    }
}
