//
//  Power.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Power measurement unit.
@objc(MeasurementPower) public enum Power: Int, CaseIterable {
    
    /// Terawatts.
    @objc(Terawatts)
    case terawatts = 1
    
    /// Gigawatts.
    @objc(Gigawatts)
    case gigawatts
    
    /// Megawatts.
    @objc(Megawatts)
    case megawatts
    
    /// Kilowatts.
    @objc(Kilowatts)
    case kilowatts
    
    /// Watts.
    @objc(Watts)
    case watts
    
    /// Milliwatts.
    @objc(Milliwatts)
    case milliwatts
    
    /// Microwatts.
    @objc(Microwatts)
    case microwatts
    
    /// Nanowatts.
    @objc(Nanowatts)
    case nanowatts
    
    /// Picowatts.
    @objc(Picowatts)
    case picowatts
    
    /// Femtowatts.
    @objc(Femtowatts)
    case femtowatts
    
    /// Mechanical horsepower.
    @objc(MechanicalHorsepower)
    case mechanicalHorsepower
    
    /// Metric horsepower.
    @objc(MetricHorsepower)
    case metricHorsepower
    
    private struct Constants {
        
        fileprivate static let terawatts            = "terawatts"
        fileprivate static let gigawatts            = "gigawatts"
        fileprivate static let megawatts            = "megawatts"
        fileprivate static let kilowatts            = "kilowatts"
        fileprivate static let watts                = "watts"
        fileprivate static let milliwatts           = "miliwatts"
        fileprivate static let microwatts           = "microwatts"
        fileprivate static let nanowatts            = "nanowatts"
        fileprivate static let picowatts            = "picowatts"
        fileprivate static let femtowatts           = "femtowatts"
        fileprivate static let mechanicalHorsepower = "mechanical_horsepower"
        fileprivate static let metricHorsepower     = "metric_horsepower"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension Power: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.terawatts            : self = .terawatts
        case Constants.gigawatts            : self = .gigawatts
        case Constants.megawatts            : self = .megawatts
        case Constants.kilowatts            : self = .kilowatts
        case Constants.watts                : self = .watts
        case Constants.milliwatts           : self = .milliwatts
        case Constants.microwatts           : self = .microwatts
        case Constants.nanowatts            : self = .nanowatts
        case Constants.picowatts            : self = .picowatts
        case Constants.femtowatts           : self = .femtowatts
        case Constants.mechanicalHorsepower : self = .mechanicalHorsepower
        case Constants.metricHorsepower     : self = .metricHorsepower
            
        default: return nil
            
        }
    }
}

// MARK: - CustomStringConvertible
extension Power: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .terawatts             : return Constants.terawatts
        case .gigawatts             : return Constants.gigawatts
        case .megawatts             : return Constants.megawatts
        case .kilowatts             : return Constants.kilowatts
        case .watts                 : return Constants.watts
        case .milliwatts            : return Constants.milliwatts
        case .microwatts            : return Constants.microwatts
        case .nanowatts             : return Constants.nanowatts
        case .picowatts             : return Constants.picowatts
        case .femtowatts            : return Constants.femtowatts
        case .mechanicalHorsepower  : return Constants.mechanicalHorsepower
        case .metricHorsepower      : return Constants.metricHorsepower
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Power: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .terawatts             : return 1_000_000_000_000.0
        case .gigawatts             : return     1_000_000_000.0
        case .megawatts             : return         1_000_000.0
        case .kilowatts             : return             1_000.0
        case .watts                 : return                 1.0
        case .milliwatts            : return                 0.001
        case .microwatts            : return                 0.000001
        case .nanowatts             : return                 0.000000001
        case .picowatts             : return                 0.000000000001
        case .femtowatts            : return                 0.000000000000001
        case .mechanicalHorsepower  : return               745.699872
        case .metricHorsepower      : return               735.49875
            
        }
    }
}
