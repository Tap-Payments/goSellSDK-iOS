//
//  Measurement.Energy.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public extension Measurement {
    
    public enum Energy {
        
        case kilojoules
        case joules
        case kilocalories
        case calories
        case kilowattHours
        
        // MARK: - Private -
        
        private struct Constants {
            
            fileprivate static let kilojoules       = "kilo_joules"
            fileprivate static let joules           = "joules"
            fileprivate static let kilocalories     = "kilo_calories"
            fileprivate static let calories         = "calories"
            fileprivate static let kilowattHours    = "kilowatt_hours"
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.Energy: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.kilojoules   : self = .kilojoules
        case Constants.joules       : self = .joules
        case Constants.kilocalories : self = .kilocalories
        case Constants.calories     : self = .calories
        case Constants.kilowattHours: self = .kilowattHours
            
        default: return nil

        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement.Energy: CountableCasesEnum {
    
    public static let all: [Measurement.Energy] = [
    
        .kilojoules,
        .joules,
        .kilocalories,
        .calories,
        .kilowattHours
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.Energy: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .kilojoules    : return Constants.kilojoules
        case .joules        : return Constants.joules
        case .kilocalories  : return Constants.kilocalories
        case .calories      : return Constants.calories
        case .kilowattHours : return Constants.kilowattHours
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Measurement.Energy: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .kilojoules    : return      1_000
        case .joules        : return          1
        case .kilocalories  : return      4_184
        case .calories      : return          4.184
        case .kilowattHours : return  3_600_000
            
        }
    }
}
