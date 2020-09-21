//
//  ElectricCurrent.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Electric current mesurement unit.
@objc(MeasurementElectricCurrent) public enum ElectricCurrent: Int, CaseIterable {
    
    /// Megaamperes.
    @objc(Megaamperes)
    case megaamperes = 1
    
    /// Kiloamperes.
    @objc(Kiloamperes)
    case kiloamperes
    
    /// Amperes.
    @objc(Amperes)
    case amperes
    
    /// Milliamperes.
    @objc(Milliamperes)
    case milliamperes
    
    /// Microamperes.
    @objc(Microamperes)
    case microamperes
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let megaamperes  = "megaamperes"
        fileprivate static let kiloamperes  = "kiloamperes"
        fileprivate static let amperes      = "amperes"
        fileprivate static let milliamperes = "milliamperes"
        fileprivate static let microamperes = "microamperes"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension ElectricCurrent: InitializableWithString {
    
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

// MARK: - CustomStringConvertible
extension ElectricCurrent: CustomStringConvertible {
    
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
extension ElectricCurrent: ProportionalToOrigin {
    
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
