//
//  Length.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Length measurement unit.
@objc(MeasurementLength) public enum Length: Int, CaseIterable {
    
    /// Megameters.
    @objc(Megameters)
    case megameters = 1
    
    /// Kilometers.
    @objc(Kilometers)
    case kilometers
    
    /// Hectometers.
    @objc(Hectometers)
    case hectometers
    
    /// Decameters.
    @objc(Decameters)
    case decameters
    
    /// Meters.
    @objc(Meters)
    case meters
    
    /// Decimeters.
    @objc(Decimeters)
    case decimeters
    
    /// Centimeters.
    @objc(Centimeters)
    case centimeters
    
    /// Millimeters.
    @objc(Millimeters)
    case millimeters
    
    /// Micrometers.
    @objc(Micrometers)
    case micrometers
    
    /// Nanometers.
    @objc(Nanometers)
    case nanometers
    
    /// Picometers.
    @objc(Picometers)
    case picometers
    
    /// Inches.
    @objc(Inches)
    case inches
    
    /// Feet.
    @objc(Feet)
    case feet
    
    /// Yards.
    @objc(Yards)
    case yards
    
    /// Miles.
    @objc(Miles)
    case miles
    
    /// Scandinavian miles.
    @objc(ScandinavianMiles)
    case scandinavianMiles
    
    /// Light years.
    @objc(LightYears)
    case lightYears
    
    /// Nautical miles.
    @objc(NauticalMiles)
    case nauticalMiles
    
    /// Fathoms.
    @objc(Fathoms)
    case fathoms
    
    /// Furlongs.
    @objc(Furlongs)
    case furlongs
    
    /// Astronomical units.
    @objc(AstronomicalUnits)
    case astronomicalUnits
    
    /// Parsecs.
    @objc(Parsecs)
    case parsecs
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let megameters           = "megameters"
        fileprivate static let kilometers           = "kilometers"
        fileprivate static let hectometers          = "hectometers"
        fileprivate static let decameters           = "decameters"
        fileprivate static let meters               = "meters"
        fileprivate static let decimeters           = "decimeters"
        fileprivate static let centimeters          = "centimeters"
        fileprivate static let millimeters          = "millimeters"
        fileprivate static let micrometers          = "micrometers"
        fileprivate static let nanometers           = "nanometers"
        fileprivate static let picometers           = "picometers"
        fileprivate static let inches               = "inches"
        fileprivate static let feet                 = "feet"
        fileprivate static let yards                = "yards"
        fileprivate static let miles                = "miles"
        fileprivate static let scandinavianMiles    = "scandinavian_miles"
        fileprivate static let lightYears           = "light_years"
        fileprivate static let nauticalMiles        = "nautical_miles"
        fileprivate static let fathoms              = "fathoms"
        fileprivate static let furlongs             = "furlongs"
        fileprivate static let astronomicalUnits    = "astronomical_units"
        fileprivate static let parsecs              = "parsecs"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension Length: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.megameters       : self = .megameters
        case Constants.kilometers       : self = .kilometers
        case Constants.hectometers      : self = .hectometers
        case Constants.decameters       : self = .decameters
        case Constants.meters           : self = .meters
        case Constants.decimeters       : self = .decimeters
        case Constants.centimeters      : self = .centimeters
        case Constants.millimeters      : self = .millimeters
        case Constants.micrometers      : self = .micrometers
        case Constants.nanometers       : self = .nanometers
        case Constants.picometers       : self = .picometers
        case Constants.inches           : self = .inches
        case Constants.feet             : self = .feet
        case Constants.yards            : self = .yards
        case Constants.miles            : self = .miles
        case Constants.scandinavianMiles: self = .scandinavianMiles
        case Constants.lightYears       : self = .lightYears
        case Constants.nauticalMiles    : self = .nauticalMiles
        case Constants.fathoms          : self = .fathoms
        case Constants.furlongs         : self = .furlongs
        case Constants.astronomicalUnits: self = .astronomicalUnits
        case Constants.parsecs          : self = .parsecs
            
        default: return nil
            
        }
    }
}

// MARK: - CustomStringConvertible
extension Length: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .megameters        : return Constants.megameters
        case .kilometers        : return Constants.kilometers
        case .hectometers       : return Constants.hectometers
        case .decameters        : return Constants.decameters
        case .meters            : return Constants.meters
        case .decimeters        : return Constants.decimeters
        case .centimeters       : return Constants.centimeters
        case .millimeters       : return Constants.millimeters
        case .micrometers       : return Constants.micrometers
        case .nanometers        : return Constants.nanometers
        case .picometers        : return Constants.picometers
        case .inches            : return Constants.inches
        case .feet              : return Constants.feet
        case .yards             : return Constants.yards
        case .miles             : return Constants.miles
        case .scandinavianMiles : return Constants.scandinavianMiles
        case .lightYears        : return Constants.lightYears
        case .nauticalMiles     : return Constants.nauticalMiles
        case .fathoms           : return Constants.fathoms
        case .furlongs          : return Constants.furlongs
        case .astronomicalUnits : return Constants.astronomicalUnits
        case .parsecs           : return Constants.parsecs
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Length: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .megameters        : return              1_000_000.0
        case .kilometers        : return                  1_000.0
        case .hectometers       : return                    100.0
        case .decameters        : return                     10.0
        case .meters            : return                      1.0
        case .decimeters        : return                      0.1
        case .centimeters       : return                      0.01
        case .millimeters       : return                      0.001
        case .micrometers       : return                      0.000001
        case .nanometers        : return                      0.000000001
        case .picometers        : return                      0.000000000001
        case .inches            : return                      0.0254
        case .feet              : return                      0.3048
        case .yards             : return                      0.9144
        case .miles             : return                   1609.34
        case .scandinavianMiles : return                 10_000.0
        case .lightYears        : return  9_460_730_472_580_800.0
        case .nauticalMiles     : return                  1_852.0
        case .fathoms           : return                      1.8288
        case .furlongs          : return                    201.168
        case .astronomicalUnits : return        149_597_870_700.0
        case .parsecs           : return 30_856_778_200_000_000.0
            
        }
    }
}
