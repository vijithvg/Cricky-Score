//
//  DeliveryMapper.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import Foundation

// MARK: - Mapper (Translates between Data and Domain layers)
enum DeliveryMapper {
    static func toDomain(from sdModel: DeliverySD) -> Delivery {
        var extras: DeliveryExtras? = nil
        if let data = sdModel.extrasData {
            extras = try? JSONDecoder().decode(DeliveryExtras.self, from: data)
        }
        
        var wicket: WicketEvent? = nil
        if let data = sdModel.wicketData {
            wicket = try? JSONDecoder().decode(WicketEvent.self, from: data)
        }
        
        return Delivery(
            id: sdModel.id,
            matchId: sdModel.matchId,
            inningsId: sdModel.inningsId,
            createdAt: sdModel.createdAt,
            isSynced: sdModel.isSynced,
            overNumber: sdModel.overNumber,
            ballNumber: sdModel.ballNumber,
            bowlerId: sdModel.bowlerId,
            strikerId: sdModel.strikerId,
            nonStrikerId: sdModel.nonStrikerId,
            runsOffBat: sdModel.runsOffBat,
            extras: extras,
            wicket: wicket
        )
    }
    
    static func toSwiftData(from domainModel: Delivery) -> DeliverySD {
        let extrasData = try? JSONEncoder().encode(domainModel.extras)
        let wicketData = try? JSONEncoder().encode(domainModel.wicket)
        
        return DeliverySD(
            id: domainModel.id,
            matchId: domainModel.matchId,
            inningsId: domainModel.inningsId,
            createdAt: domainModel.createdAt,
            isSynced: domainModel.isSynced,
            overNumber: domainModel.overNumber,
            ballNumber: domainModel.ballNumber,
            bowlerId: domainModel.bowlerId,
            strikerId: domainModel.strikerId,
            nonStrikerId: domainModel.nonStrikerId,
            runsOffBat: domainModel.runsOffBat,
            extrasData: extrasData,
            wicketData: wicketData
        )
    }
}
