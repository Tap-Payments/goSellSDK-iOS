//
//  MeasurementUnit.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public enum MeasurementUnit: Int {
    
    case kilograms
    case units
    
    // MARK: - Private -
    
    private struct RawValues {
        
        fileprivate static let kilograms = "kg"
        fileprivate static let units = "units"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .kilograms: return RawValues.kilograms
        case .units: return RawValues.units
        }
    }
    
    // MARK: Methods
    
    /// Initializes an enum with the string value.
    ///
    /// - Parameter stringValue: String representation of measurement unit.
    /// - Throws: Invalid unit of measurement error
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case RawValues.kilograms:
            
            self = .kilograms
            
        case RawValues.units:
            
            self = .units
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.unitOfMeasurement: stringValue]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidUnitOfMeasurement.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
    }
}

// MARK: - Encodable
extension MeasurementUnit: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
