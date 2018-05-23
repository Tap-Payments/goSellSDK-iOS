//
//  MeasurementLength.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum MeasurementLength {
    
    case megameters
    case kilometers
    case hectometers
    case decameters
    case meters
    case decimeters
    case centimeters
    case millimeters
    case micrometers
    case nanometers
    case picometers
    case inches
    case feet
    case yards
    case miles
    case scandinavianMiles
    case lightYears
    case nauticalMiles
    case fathoms
    case furlongs
    case astronomicalUnits
    case parsecs
}

// MARK: - CustomStringConvertible
extension MeasurementLength: CustomStringConvertible {
    
    public var description: String {
        
        return "meter"
    }
}

// MARK: - ProportionalToOrigin
extension MeasurementLength: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .megameters:        return              1_000_000
        case .kilometers:        return                  1_000
        case .hectometers:       return                    100
        case .decameters:        return                     10
        case .meters:            return                      1
        case .decimeters:        return                      0.1
        case .centimeters:       return                      0.01
        case .millimeters:       return                      0.001
        case .micrometers:       return                      0.000001
        case .nanometers:        return                      0.000000001
        case .picometers:        return                      0.000000000001
        case .inches:            return                      0.0254
        case .feet:              return                      0.3048
        case .yards:             return                      0.9144
        case .miles:             return                   1609.34
        case .scandinavianMiles: return                 10_000
        case .lightYears:        return  9_460_730_472_580_800
        case .nauticalMiles:     return                  1_852
        case .fathoms:           return                      1.8288
        case .furlongs:          return                    201.168
        case .astronomicalUnits: return        149_597_870_700
        case .parsecs:           return 30_856_778_200_000_000

        }
    }
}
