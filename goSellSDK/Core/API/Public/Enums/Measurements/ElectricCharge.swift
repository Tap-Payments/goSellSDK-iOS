//
//  ElectricCharge.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Electric charge measurement unit.
@objc(MeasurementElectricCharge) public enum ElectricCharge: Int, CaseIterable {
    
    /// Coulombs.
    @objc(Coulombs)
    case coulombs = 1
    
    /// Megaampere hours.
    @objc(MegaampereHours)
    case megaampereHours
    
    /// Kiloampere hours.
    @objc(KiloampereHours)
    case kiloampereHours
    
    /// Ampere hours.
    @objc(AmpereHours)
    case ampereHours
    
    /// Milliampere hours.
    @objc(MilliampereHours)
    case milliampereHours
    
    /// Micorampere hours.
    @objc(MicroampereHours)
    case microampereHours
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let coulombs         = "coulombs"
        fileprivate static let megaampereHours  = "megaampere_hours"
        fileprivate static let kiloampereHours  = "kiloampere_hours"
        fileprivate static let ampereHours      = "ampere_hours"
        fileprivate static let milliampereHours = "milliampere_hours"
        fileprivate static let microampereHours = "microampere_hours"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension ElectricCharge: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.coulombs         : self = .coulombs
        case Constants.megaampereHours  : self = .megaampereHours
        case Constants.kiloampereHours  : self = .kiloampereHours
        case Constants.ampereHours      : self = .ampereHours
        case Constants.milliampereHours : self = .milliampereHours
        case Constants.microampereHours : self = .microampereHours
            
        default: return nil
            
        }
    }
}

// MARK: - CustomStringConvertible
extension ElectricCharge: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .coulombs          : return Constants.coulombs
        case .megaampereHours   : return Constants.megaampereHours
        case .kiloampereHours   : return Constants.kiloampereHours
        case .ampereHours       : return Constants.ampereHours
        case .milliampereHours  : return Constants.milliampereHours
        case .microampereHours  : return Constants.microampereHours
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension ElectricCharge: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .coulombs          : return              1.0
        case .megaampereHours   : return  3_600_000_000.0
        case .kiloampereHours   : return      3_600_000.0
        case .ampereHours       : return          3_600.0
        case .milliampereHours  : return              3.6
        case .microampereHours  : return              0.0036
            
        }
    }
}
