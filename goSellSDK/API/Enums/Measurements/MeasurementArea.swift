//
//  MeasurementArea.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum MeasurementArea {
    
    case squareMegameters
    case squareKilometers
    case squareMeters
    case squareCentimeters
    case squareMillimeters
    case squareMicrometers
    case squareNanometers
    case squareInches
    case squareFeet
    case squareYards
    case squareMiles
    case acres
    case ares
    case hectares
}

// MARK: - CustomStringConvertible
extension MeasurementArea: CustomStringConvertible {
    
    public var description: String {
        
        return "sqm"
    }
}

// MARK: - ProportionalToOrigin
extension MeasurementArea: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .squareMegameters:  return 1_000_000_000_000
        case .squareKilometers:  return         1_000_000
        case .squareMeters:      return                 1
        case .squareCentimeters: return                 0.0001
        case .squareMillimeters: return                 0.000001
        case .squareMicrometers: return                 0.000000000001
        case .squareNanometers:  return                 0.000000000000000001
        case .squareInches:      return                 0.00064516
        case .squareFeet:        return                 0.09290304
        case .squareYards:       return                 0.83612736
        case .squareMiles:       return         2_589_988.110336
        case .acres:             return             4_046.8564224
        case .ares:              return               100
        case .hectares:          return            10_000
        }
    }
}
