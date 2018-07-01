//
//  Measurement.Volume.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Volume extension to Measurement.
public extension Measurement {
    
    /// Volume measurement unit.
    public enum Volume {
        
        /// Megaliters.
        case megaliters
        
        /// Kiloliters.
        case kiloliters
        
        /// Liters.
        case liters
        
        /// Deciliters.
        case deciliters
        
        /// Centiliters.
        case centiliters
        
        /// Milliliters.
        case milliliters
        
        /// Cubic kilometers.
        case cubicKilometers
        
        /// Cubic meters.
        case cubicMeters
        
        /// Cubic decimeters.
        case cubicDecimeters
        
        /// Cubic centimeters.
        case cubicCentimeters
        
        /// Cubic millimeters.
        case cubicMillimeters
        
        /// Cubic inches.
        case cubicInches
        
        /// Cubic feet.
        case cubicFeet
        
        /// Cubic yards.
        case cubicYards
        
        /// Cubic miles.
        case cubicMiles
        
        /// Acre feet.
        case acreFeet
        
        /// Bushels.
        case bushels
        
        /// Tea spoons.
        case teaspoons
        
        /// Table spoons.
        case tablespoons
        
        /// Fluid ounces.
        case fluidOunces
        
        /// Cups.
        case cups
        
        /// Pints.
        case pints
        
        /// Quarts.
        case quarts
        
        /// Gallons.
        case gallons
        
        /// Imperial tea spoons.
        case imperialTeaspoons
        
        /// Imperial table spoons.
        case imperialTablespoons
        
        /// Imperial fluid ounces.
        case imperialFluidOunces
        
        /// Imperial pints.
        case imperialPints
        
        /// Imperial quarts.
        case imperialQuarts
        
        /// Imperial gallons.
        case imperialGallons
        
        /// Metric cups.
        case metricCups
        
        // MARK: - Private -
        
        private struct Constants {
            
            fileprivate static let megaliters           = "megaliters"
            fileprivate static let kiloliters           = "kiloliters"
            fileprivate static let liters               = "liters"
            fileprivate static let deciliters           = "deciliters"
            fileprivate static let centiliters          = "centiliters"
            fileprivate static let milliliters          = "milliliters"
            fileprivate static let cubicKilometers      = "cubic_kilometers"
            fileprivate static let cubicMeters          = "cubic_meters"
            fileprivate static let cubicDecimeters      = "cubic_decimeters"
            fileprivate static let cubicCentimeters     = "cubic_centimeters"
            fileprivate static let cubicMillimeters     = "cubic_millimeters"
            fileprivate static let cubicInches          = "cubic_inches"
            fileprivate static let cubicFeet            = "cubic_feet"
            fileprivate static let cubicYards           = "cubic_yards"
            fileprivate static let cubicMiles           = "cubic_miles"
            fileprivate static let acreFeet             = "acre_feet"
            fileprivate static let bushels              = "bushels"
            fileprivate static let teaspoons            = "teaspoons"
            fileprivate static let tablespoons          = "tablespoons"
            fileprivate static let fluidOunces          = "fluid_ounces"
            fileprivate static let cups                 = "cups"
            fileprivate static let pints                = "pints"
            fileprivate static let quarts               = "quarts"
            fileprivate static let gallons              = "gallons"
            fileprivate static let imperialTeaspoons    = "imperial_teaspoons"
            fileprivate static let imperialTablespoons  = "imperial_tablespoons"
            fileprivate static let imperialFluidOunces  = "imperial_fluid_ounces"
            fileprivate static let imperialPints        = "imperial_pints"
            fileprivate static let imperialQuarts       = "imperial_quarts"
            fileprivate static let imperialGallons      = "imperial_gallons"
            fileprivate static let metricCups           = "metric_cups"
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.Volume: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.megaliters           : self = .megaliters
        case Constants.kiloliters           : self = .kiloliters
        case Constants.liters               : self = .liters
        case Constants.deciliters           : self = .deciliters
        case Constants.centiliters          : self = .centiliters
        case Constants.milliliters          : self = .milliliters
        case Constants.cubicKilometers      : self = .cubicKilometers
        case Constants.cubicMeters          : self = .cubicMeters
        case Constants.cubicDecimeters      : self = .cubicDecimeters
        case Constants.cubicCentimeters     : self = .cubicCentimeters
        case Constants.cubicMillimeters     : self = .cubicMillimeters
        case Constants.cubicInches          : self = .cubicInches
        case Constants.cubicFeet            : self = .cubicFeet
        case Constants.cubicYards           : self = .cubicYards
        case Constants.cubicMiles           : self = .cubicMiles
        case Constants.acreFeet             : self = .acreFeet
        case Constants.bushels              : self = .bushels
        case Constants.teaspoons            : self = .teaspoons
        case Constants.tablespoons          : self = .tablespoons
        case Constants.fluidOunces          : self = .fluidOunces
        case Constants.cups                 : self = .cups
        case Constants.pints                : self = .pints
        case Constants.quarts               : self = .quarts
        case Constants.gallons              : self = .gallons
        case Constants.imperialTeaspoons    : self = .imperialTeaspoons
        case Constants.imperialTablespoons  : self = .imperialTablespoons
        case Constants.imperialFluidOunces  : self = .imperialFluidOunces
        case Constants.imperialPints        : self = .imperialPints
        case Constants.imperialQuarts       : self = .imperialQuarts
        case Constants.imperialGallons      : self = .imperialGallons
        case Constants.metricCups           : self = .metricCups
            
        default: return nil
            
        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement.Volume: CountableCasesEnum {
    
    public static let all: [Measurement.Volume] = [
        
        .megaliters,
        .kiloliters,
        .liters,
        .deciliters,
        .centiliters,
        .milliliters,
        .cubicKilometers,
        .cubicMeters,
        .cubicDecimeters,
        .cubicCentimeters,
        .cubicMillimeters,
        .cubicInches,
        .cubicFeet,
        .cubicYards,
        .cubicMiles,
        .acreFeet,
        .bushels,
        .teaspoons,
        .tablespoons,
        .fluidOunces,
        .cups,
        .pints,
        .quarts,
        .gallons,
        .imperialTeaspoons,
        .imperialTablespoons,
        .imperialFluidOunces,
        .imperialPints,
        .imperialQuarts,
        .imperialGallons,
        .metricCups
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.Volume: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .megaliters           : return Constants.megaliters
        case .kiloliters           : return Constants.kiloliters
        case .liters               : return Constants.liters
        case .deciliters           : return Constants.deciliters
        case .centiliters          : return Constants.centiliters
        case .milliliters          : return Constants.milliliters
        case .cubicKilometers      : return Constants.cubicKilometers
        case .cubicMeters          : return Constants.cubicMeters
        case .cubicDecimeters      : return Constants.cubicDecimeters
        case .cubicCentimeters     : return Constants.cubicCentimeters
        case .cubicMillimeters     : return Constants.cubicMillimeters
        case .cubicInches          : return Constants.cubicInches
        case .cubicFeet            : return Constants.cubicFeet
        case .cubicYards           : return Constants.cubicYards
        case .cubicMiles           : return Constants.cubicMiles
        case .acreFeet             : return Constants.acreFeet
        case .bushels              : return Constants.bushels
        case .teaspoons            : return Constants.teaspoons
        case .tablespoons          : return Constants.tablespoons
        case .fluidOunces          : return Constants.fluidOunces
        case .cups                 : return Constants.cups
        case .pints                : return Constants.pints
        case .quarts               : return Constants.quarts
        case .gallons              : return Constants.gallons
        case .imperialTeaspoons    : return Constants.imperialTeaspoons
        case .imperialTablespoons  : return Constants.imperialTablespoons
        case .imperialFluidOunces  : return Constants.imperialFluidOunces
        case .imperialPints        : return Constants.imperialPints
        case .imperialQuarts       : return Constants.imperialQuarts
        case .imperialGallons      : return Constants.imperialGallons
        case .metricCups           : return Constants.metricCups
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Measurement.Volume: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .megaliters           : return         1_000.0
        case .kiloliters           : return             1.0
        case .liters               : return             0.001
        case .deciliters           : return             0.0001
        case .centiliters          : return             0.00001
        case .milliliters          : return             0.000001
        case .cubicKilometers      : return 1_000_000_000.0
        case .cubicMeters          : return             1.0
        case .cubicDecimeters      : return             0.001
        case .cubicCentimeters     : return             0.000001
        case .cubicMillimeters     : return             0.000000001
        case .cubicInches          : return             0.0000163871
        case .cubicFeet            : return             0.0283168466
        case .cubicYards           : return             0.764554858
        case .cubicMiles           : return 4_168_181_825.4
        case .acreFeet             : return         1_233.4818375
        case .bushels              : return             0.03636872
        case .teaspoons            : return             0.000005
        case .tablespoons          : return             0.000015
        case .fluidOunces          : return             0.000029573529563
        case .cups                 : return             0.00025
        case .pints                : return             0.000473176473
        case .quarts               : return             0.000946352946
        case .gallons              : return             0.003785411784
        case .imperialTeaspoons    : return             0.00000591938802083
        case .imperialTablespoons  : return             0.0000177581640625
        case .imperialFluidOunces  : return             0.0000284130625
        case .imperialPints        : return             0.0005683
        case .imperialQuarts       : return             0.0011365
        case .imperialGallons      : return             0.0045461
        case .metricCups           : return             0.00025
            
        }
    }
}
