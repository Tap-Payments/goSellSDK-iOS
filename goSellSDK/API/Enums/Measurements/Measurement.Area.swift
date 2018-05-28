//
//  Measurement.Area.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public extension Measurement {
    
    public enum Area {
        
        case squareMegameters
        case squareKilometers
        case squareMeters
        case squareCentimeters
        case squareMillimeters
        case squareMicrometers
        case squareNanometers
        case squareInches
        case squareFeet
        case squareYards
        case squareMiles
        case acres
        case ares
        case hectares
        
        // MARK: - Private -
        
        private struct Constants {
            
            fileprivate static let squareMegameters     = "square_megameters"
            fileprivate static let squareKilometers     = "square_kilometers"
            fileprivate static let squareMeters         = "square_meters"
            fileprivate static let squareCentimeters    = "square_centimeters"
            fileprivate static let squareMillimeters    = "square_millimeters"
            fileprivate static let squareMicrometers    = "square_micrometers"
            fileprivate static let squareNanometers     = "square_nanometers"
            fileprivate static let squareInches         = "square_inches"
            fileprivate static let squareFeet           = "square_feet"
            fileprivate static let squareYards          = "square_yards"
            fileprivate static let squareMiles          = "square_miles"
            fileprivate static let acres                = "acres"
            fileprivate static let ares                 = "ares"
            fileprivate static let hectares             = "hectares"
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.Area: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.squareMegameters : self = .squareMegameters
        case Constants.squareKilometers : self = .squareKilometers
        case Constants.squareMeters     : self = .squareMeters
        case Constants.squareCentimeters: self = .squareCentimeters
        case Constants.squareMillimeters: self = .squareMillimeters
        case Constants.squareMicrometers: self = .squareMicrometers
        case Constants.squareNanometers : self = .squareNanometers
        case Constants.squareInches     : self = .squareInches
        case Constants.squareFeet       : self = .squareFeet
        case Constants.squareYards      : self = .squareYards
        case Constants.squareMiles      : self = .squareMiles
        case Constants.acres            : self = .acres
        case Constants.ares             : self = .ares
        case Constants.hectares         : self = .hectares
            
        default: return nil
            
        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement.Area: CountableCasesEnum {
    
    public static let all: [Measurement.Area] = [
        
        .squareMegameters,
        .squareKilometers,
        .squareMeters,
        .squareCentimeters,
        .squareMillimeters,
        .squareMicrometers,
        .squareNanometers,
        .squareInches,
        .squareFeet,
        .squareYards,
        .squareMiles,
        .acres,
        .ares,
        .hectares
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.Area: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .squareMegameters  : return Constants.squareMegameters
        case .squareKilometers  : return Constants.squareKilometers
        case .squareMeters      : return Constants.squareMeters
        case .squareCentimeters : return Constants.squareCentimeters
        case .squareMillimeters : return Constants.squareMillimeters
        case .squareMicrometers : return Constants.squareMicrometers
        case .squareNanometers  : return Constants.squareNanometers
        case .squareInches      : return Constants.squareInches
        case .squareFeet        : return Constants.squareFeet
        case .squareYards       : return Constants.squareYards
        case .squareMiles       : return Constants.squareMiles
        case .acres             : return Constants.acres
        case .ares              : return Constants.ares
        case .hectares          : return Constants.hectares
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Measurement.Area: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .squareMegameters  : return 1_000_000_000_000
        case .squareKilometers  : return         1_000_000
        case .squareMeters      : return                 1
        case .squareCentimeters : return                 0.0001
        case .squareMillimeters : return                 0.000001
        case .squareMicrometers : return                 0.000000000001
        case .squareNanometers  : return                 0.000000000000000001
        case .squareInches      : return                 0.00064516
        case .squareFeet        : return                 0.09290304
        case .squareYards       : return                 0.83612736
        case .squareMiles       : return         2_589_988.110336
        case .acres             : return             4_046.8564224
        case .ares              : return               100
        case .hectares          : return            10_000
        }
    }
}
