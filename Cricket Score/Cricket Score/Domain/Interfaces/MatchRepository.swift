//
//  MatchRepository.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation
// MARK: - Repository Protocol
protocol MatchRepository {
    func saveDelivery(_ delivery: Delivery) async throws
    func fetchDeliveries(forInnings inningsId: UUID) async throws -> [Delivery]
    func deleteDelivery(id: UUID) async throws
}
