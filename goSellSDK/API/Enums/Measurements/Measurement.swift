//
//  Measurement.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum Measurement {
    
    case area(MeasurementArea)
    case length(MeasurementLength)
    case mass(MeasurementMass)
    case units
}

extension Measurement: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .area(_):      return "area"
        case .length(_):    return "length"
        case .mass(_):      return "weight"
        case .units:        return "units"
        }
    }
}
