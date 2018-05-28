//
//  Measurement.Length.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public extension Measurement {
    
    public enum Length {
        
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
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.Length: InitializableWithString {
    
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

// MARK: - CountableCasesEnum
extension Measurement.Length: CountableCasesEnum {
    
    public static let all: [Measurement.Length] = [
        
        .megameters,
        .kilometers,
        .hectometers,
        .decameters,
        .meters,
        .decimeters,
        .centimeters,
        .millimeters,
        .micrometers,
        .nanometers,
        .picometers,
        .inches,
        .feet,
        .yards,
        .miles,
        .scandinavianMiles,
        .lightYears,
        .nauticalMiles,
        .fathoms,
        .furlongs,
        .astronomicalUnits,
        .parsecs
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.Length: CustomStringConvertible {
    
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
extension Measurement.Length: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .megameters        : return              1_000_000
        case .kilometers        : return                  1_000
        case .hectometers       : return                    100
        case .decameters        : return                     10
        case .meters            : return                      1
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
        case .scandinavianMiles : return                 10_000
        case .lightYears        : return  9_460_730_472_580_800
        case .nauticalMiles     : return                  1_852
        case .fathoms           : return                      1.8288
        case .furlongs          : return                    201.168
        case .astronomicalUnits : return        149_597_870_700
        case .parsecs           : return 30_856_778_200_000_000
            
        }
    }
}
