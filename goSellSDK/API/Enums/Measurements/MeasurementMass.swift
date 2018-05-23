//
//  MeasurementMass.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum MeasurementMass {
    
    case kilograms
    case grams
    case decigrams
    case centigrams
    case milligrams
    case micrograms
    case nanograms
    case picograms
    case ounces
    case pounds
    case stones
    case metricTons
    case shortTons
    case carats
    case ouncesTroy
    case slugs
}

extension MeasurementMass: CustomStringConvertible {
    
    public var description: String {
        
        return "kg"
    }
}

// MARK: - ProportionalToOrigin
extension MeasurementMass: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .kilograms:    return     1
        case .grams:        return     0.001
        case .decigrams:    return     0.0001
        case .centigrams:   return     0.00001
        case .milligrams:   return     0.000001
        case .micrograms:   return     0.000000001
        case .nanograms:    return     0.000000000001
        case .picograms:    return     0.000000000000001
        case .ounces:       return     0.028349523125
        case .pounds:       return     0.45359237
        case .stones:       return     6.35029318
        case .metricTons:   return 1_000
        case .shortTons:    return   907.18474
        case .carats:       return     0.000205196548333
        case .ouncesTroy:   return     0.0311034768
        case .slugs:        return    14.593903
        }
    }
}
