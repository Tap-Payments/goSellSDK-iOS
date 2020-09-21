//
//  Energy.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Energy measurement unit.
@objc(MeasurementEnergy) public enum Energy: Int, CaseIterable {
    
    /// Kilojoules.
    @objc(Kilojoules)
    case kilojoules = 1
    
    /// Joules.
    @objc(Joules)
    case joules
    
    /// Kilocalories.
    @objc(Kilocalories)
    case kilocalories
    
    /// Calories.
    @objc(Calories)
    case calories
    
    /// Kilowatt-hours.
    @objc(KilowattHours)
    case kilowattHours
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let kilojoules       = "kilojoules"
        fileprivate static let joules           = "joules"
        fileprivate static let kilocalories     = "kilocalories"
        fileprivate static let calories         = "calories"
        fileprivate static let kilowattHours    = "kilowatt_hours"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension Energy: InitializableWithString {
    
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

// MARK: - CustomStringConvertible
extension Energy: CustomStringConvertible {
    
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
extension Energy: ProportionalToOrigin {
    
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
