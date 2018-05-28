//
//  Measurement.Duration.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public extension Measurement {
    
    public enum Duration {
        
        case seconds
        case minutes
        case hours
        case days
        case weeks
        
        // MARK: - Private -
        
        private struct Constants {
            
            fileprivate static let seconds  = "seconds"
            fileprivate static let minutes  = "minutes"
            fileprivate static let hours    = "hours"
            fileprivate static let days     = "days"
            fileprivate static let weeks    = "weeks"
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - InitializableWithString
extension Measurement.Duration: InitializableWithString {
    
    internal init?(string: String) {
        
        switch string {
            
        case Constants.seconds  : self = .seconds
        case Constants.minutes  : self = .minutes
        case Constants.hours    : self = .hours
        case Constants.days     : self = .days
        case Constants.weeks    : self = .weeks
            
        default: return nil

        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement.Duration: CountableCasesEnum {
    
    public static let all: [Measurement.Duration] = [
    
        .seconds,
        .minutes,
        .hours,
        .days,
        .weeks
    ]
}

// MARK: - CustomStringConvertible
extension Measurement.Duration: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .seconds   : return Constants.seconds
        case .minutes   : return Constants.minutes
        case .hours     : return Constants.hours
        case .days      : return Constants.days
        case .weeks     : return Constants.weeks
            
        }
    }
}

// MARK: - ProportionalToOrigin
extension Measurement.Duration: ProportionalToOrigin {
    
    internal var inUnitsOfOrigin: Decimal {
        
        switch self {
            
        case .seconds   : return       1
        case .minutes   : return      60
        case .hours     : return   3_600
        case .days      : return  86_400
        case .weeks     : return 604_800
            
        }
    }
}
