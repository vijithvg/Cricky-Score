//
//  WicketEvent.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

// MARK: - Delivery Extras
enum DeliveryExtras: Codable {
    case wide
    case noBall
    case bye(runs: Int)
    case legBye(runs: Int)
    case penalty(runs: Int)
    
    var runValue: Int {
        switch self {
        case .wide, .noBall: return 1
        case .bye(let runs), .legBye(let runs), .penalty(let runs): return runs
        }
    }
}
