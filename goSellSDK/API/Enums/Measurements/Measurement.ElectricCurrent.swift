//
//  Measurement.ElectricCurrent.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Electric current extension to Measurement.
public extension Measurement {
    
    /// Electric current mesurement unit.
    public enum ElectricCurrent {
        
        /// Megaamperes.
        case megaamperes
        
        /// Kiloamperes.
        case kiloamperes
        
        /// Amperes.
        case amperes
        
        /// Milliamperes.
        case milliamperes
        
        /// Microamperes.
        case microamperes
        
        // MARK: - Private -
        
        private struct Constants {
            
            fileprivate static let megaamperes  = "megaamperes"
            fileprivate static let kiloamperes  = "kiloamperes"
            fileprivate static let amperes      = "amperes"
            fileprivate static let milliamperes = "milliamperes"
            fileprivate static let microamperes = "microamperes"
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.ElectricCurrent: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.megaamperes  : self = .megaamperes
        case Constants.kiloamperes  : self = .kiloamperes
        case Constants.amperes      : self = .amperes
        case Constants.milliamperes : self = .milliamperes
        case Constants.microamperes : self = .microamperes
            
        default: return nil

        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement.ElectricCurrent: CountableCasesEnum {
    
    public static let all: [Measurement.ElectricCurrent] = [
        
        .megaamperes,
        .kiloamperes,
        .amperes,
        .milliamperes,
        .microamperes
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.ElectricCurrent: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .megaamperes   : return Constants.megaamperes
        case .kiloamperes   : return Constants.kiloamperes
        case .amperes       : return Constants.amperes
        case .milliamperes  : return Constants.milliamperes
        case .microamperes  : return Constants.microamperes

        }
    }
}

// MARK: - ProportionalToOrigin
extension Measurement.ElectricCurrent: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .megaamperes   : return  1_000_000
        case .kiloamperes   : return      1_000
        case .amperes       : return          1
        case .milliamperes  : return          0.001
        case .microamperes  : return          0.000001
            
        }
    }
}
