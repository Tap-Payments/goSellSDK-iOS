//
//  Mass.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Mass measurement unit.
@objc(MeasurementMass) public enum Mass: Int, CaseIterable {
    
    /// Kilograms.
    @objc(Kilograms)
    case kilograms = 1
    
    /// Grams.
    @objc(Grams)
    case grams
    
    /// Decigrams.
    @objc(Decigrams)
    case decigrams
    
    /// Centigrams.
    @objc(Centigrams)
    case centigrams
    
    /// Milligrams.
    @objc(Milligrams)
    case milligrams
    
    /// Micrograms.
    @objc(Micrograms)
    case micrograms
    
    /// Nanograms.
    @objc(Nanograms)
    case nanograms
    
    /// Picograms.
    @objc(Picograms)
    case picograms
    
    /// Ounces.
    @objc(Ounces)
    case ounces
    
    /// Pounds.
    @objc(Pounds)
    case pounds
    
    /// Stones.
    @objc(Stones)
    case stones
    
    /// Metric tons.
    @objc(MetricTons)
    case metricTons
    
    /// Short tons.
    @objc(ShortTons)
    case shortTons
    
    /// Carats.
    @objc(Carats)
    case carats
    
    /// Ounces troy.
    @objc(OuncesTroy)
    case ouncesTroy
    
    /// Slugs.
    @objc(Slugs)
    case slugs
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let kilograms    = "kilograms"
        fileprivate static let grams        = "grams"
        fileprivate static let decigrams    = "decigrams"
        fileprivate static let centigrams   = "centigrams"
        fileprivate static let milligrams   = "milligrams"
        fileprivate static let micrograms   = "micrograms"
        fileprivate static let nanograms    = "nanograms"
        fileprivate static let picograms    = "picograms"
        fileprivate static let ounces       = "ounces"
        fileprivate static let pounds       = "pounds"
        fileprivate static let stones       = "stones"
        fileprivate static let metricTons   = "metric_tons"
        fileprivate static let shortTons    = "short_tons"
        fileprivate static let carats       = "carats"
        fileprivate static let ouncesTroy   = "ounces_troy"
        fileprivate static let slugs        = "slugs"
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - InitializableWithString
extension Mass: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.kilograms    : self = .kilograms
        case Constants.grams        : self = .grams
        case Constants.decigrams    : self = .decigrams
        case Constants.centigrams   : self = .centigrams
        case Constants.milligrams   : self = .milligrams
        case Constants.micrograms   : self = .micrograms
        case Constants.nanograms    : self = .nanograms
        case Constants.picograms    : self = .picograms
        case Constants.ounces       : self = .ounces
        case Constants.pounds       : self = .pounds
        case Constants.stones       : self = .stones
        case Constants.metricTons   : self = .metricTons
        case Constants.shortTons    : self = .shortTons
        case Constants.carats       : self = .carats
        case Constants.ouncesTroy   : self = .ouncesTroy
        case Constants.slugs        : self = .slugs
            
        default: return nil
            
        }
    }
}

// MARK: - CustomStringConvertible
extension Mass: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .kilograms : return Constants.kilograms
        case .grams     : return Constants.grams
        case .decigrams : return Constants.decigrams
        case .centigrams: return Constants.centigrams
        case .milligrams: return Constants.milligrams
        case .micrograms: return Constants.micrograms
        case .nanograms : return Constants.nanograms
        case .picograms : return Constants.picograms
        case .ounces    : return Constants.ounces
        case .pounds    : return Constants.pounds
        case .stones    : return Constants.stones
        case .metricTons: return Constants.metricTons
        case .shortTons : return Constants.shortTons
        case .carats    : return Constants.carats
        case .ouncesTroy: return Constants.ouncesTroy
        case .slugs     : return Constants.slugs
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Mass: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .kilograms : return     1
        case .grams     : return     0.001
        case .decigrams : return     0.0001
        case .centigrams: return     0.00001
        case .milligrams: return     0.000001
        case .micrograms: return     0.000000001
        case .nanograms : return     0.000000000001
        case .picograms : return     0.000000000000001
        case .ounces    : return     0.028349523125
        case .pounds    : return     0.45359237
        case .stones    : return     6.35029318
        case .metricTons: return 1_000
        case .shortTons : return   907.18474
        case .carats    : return     0.000205196548333
        case .ouncesTroy: return     0.0311034768
        case .slugs     : return    14.593903
        }
    }
}
