//
//  LocalMatchRepository.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation
import SwiftData

// MARK: - Repository Implementation (Data Layer)
@MainActor
final class LocalMatchRepository: MatchRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDelivery(_ delivery: Delivery) async throws {
        // Map pure Swift struct to SwiftData model
        let sdModel = DeliveryMapper.toSwiftData(from: delivery)
        
        // Insert and save via ModelContext
        modelContext.insert(sdModel)
        try modelContext.save()
    }
    
    func fetchDeliveries(forInnings inningsId: UUID) async throws -> [Delivery] {
        // Fetch from database, sorted chronologically
        let descriptor = FetchDescriptor<DeliverySD>(
            predicate: #Predicate { $0.inningsId == inningsId },
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        
        let sdDeliveries = try modelContext.fetch(descriptor)
        
        // Map back to pure Swift structs for the Domain layer
        return sdDeliveries.map { DeliveryMapper.toDomain(from: $0) }
    }
    
    func deleteDelivery(id: UUID) async throws {
        let descriptor = FetchDescriptor<DeliverySD>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let deliveryToDelete = try modelContext.fetch(descriptor).first {
            modelContext.delete(deliveryToDelete)
            try modelContext.save()
        }
    }
}
