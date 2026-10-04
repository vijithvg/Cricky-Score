//
//  DIContainer.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation
import SwiftData
import Observation

// MARK: - Dependency Injection Container
@Observable
@MainActor
final class DIContainer {
    // MARK: Shared Resources
    let modelContainer: ModelContainer
    let matchRepository: MatchRepository
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: DeliverySD.self)
            self.matchRepository = LocalMatchRepository(modelContext: modelContainer.mainContext)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    // MARK: - Use Case Factories
    func makeRecordDeliveryUseCase() -> RecordDeliveryUseCaseProtocol {
        return RecordDeliveryUseCase(repository: matchRepository)
    }
    
    // MARK: - ViewModel Factories
    func makeScoringViewModel(
        matchId: UUID = UUID(),
        inningsId: UUID = UUID(),
        strikerId: UUID = UUID(),
        nonStrikerId: UUID = UUID(),
        bowlerId: UUID = UUID()
    ) -> ScoringViewModel {
        return ScoringViewModel(
            matchId: matchId,
            inningsId: inningsId,
            strikerId: strikerId,
            nonStrikerId: nonStrikerId,
            bowlerId: bowlerId,
            recordDeliveryUseCase: makeRecordDeliveryUseCase()
        )
    }
}
