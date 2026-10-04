//
//  MockMatchRepository.swift
//  Cricket Score
//
//  Created by Vijith V G on 02/10/26.
//

import XCTest
@testable import Cricket_Score // Replace with your app's actual module name

// MARK: - 1. Mock Repository
/// A test double that conforms to MatchRepository, keeping data in memory instead of using SwiftData.
 @MainActor
final class MockMatchRepository: MatchRepository {
    var deliveries: [Delivery] = []
    
    // Tracking flags to verify if methods were actually called during the test
    var didCallSave = false
    var didCallDelete = false
    
    func saveDelivery(_ delivery: Delivery) async throws {
        deliveries.append(delivery)
        didCallSave = true
    }
    
    func fetchDeliveries(forInnings inningsId: UUID) async throws -> [Delivery] {
        return deliveries.filter { $0.inningsId == inningsId }
    }
    
    func deleteDelivery(id: UUID) async throws {
        deliveries.removeAll { $0.id == id }
        didCallDelete = true
    }
}

// MARK: - 2. Use Case Tests
@MainActor
final class RecordDeliveryUseCaseTests: XCTestCase {
    // System Under Test (SUT) and its dependencies
    var mockRepository: MockMatchRepository!
    var useCase: RecordDeliveryUseCase!
    
    override func setUp() {
        super.setUp()
        // Initialize a fresh mock and use case before every single test
        mockRepository = MockMatchRepository()
        useCase = RecordDeliveryUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        // Deallocate objects after every test to prevent memory leaks between test runs
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testRunLimitValidationThrowsError() async {
            let request = RecordDeliveryRequest(
                matchId: UUID(), inningsId: UUID(), overNumber: 0, ballNumber: 1,
                bowlerId: UUID(), strikerId: UUID(), nonStrikerId: UUID(),
                runsOffBat: 7, extras: nil, wicket: nil
            )
            
            do {
                _ = try await useCase.execute(request: request)
                XCTFail("Expected an error to be thrown because runs off bat exceeded 6.")
            } catch {
                XCTAssertNotNil(error)
                
                // 1. Extract isolated properties to local constants
                let didCallSave = mockRepository.didCallSave
                let deliveryCount = mockRepository.deliveries.count
                
                // 2. Pass the local constants to XCTAssert
                XCTAssertFalse(didCallSave, "Data should not be saved if validation fails.")
                XCTAssertEqual(deliveryCount, 0)
            }
        }
        
        func testSuccessfulDeliverySave() async throws {
            let request = RecordDeliveryRequest(
                matchId: UUID(), inningsId: UUID(), overNumber: 0, ballNumber: 1,
                bowlerId: UUID(), strikerId: UUID(), nonStrikerId: UUID(),
                runsOffBat: 4, extras: nil, wicket: nil
            )
            
            let delivery = try await useCase.execute(request: request)
            
            // 1. Extract isolated properties to local constants
            let didCallSave = mockRepository.didCallSave
            let deliveryCount = mockRepository.deliveries.count
            let firstDeliveryId = mockRepository.deliveries.first?.id
            
            // 2. Pass the local constants to XCTAssert
            XCTAssertEqual(delivery.runsOffBat, 4)
            XCTAssertNotEqual(delivery.runsOffBat, 3)
            XCTAssertTrue(didCallSave, "The repository save method must be triggered.")
            XCTAssertEqual(deliveryCount, 1, "Exactly one delivery should be stored.")
            XCTAssertEqual(firstDeliveryId, delivery.id, "The saved entity should match the returned entity.")
        }
}
