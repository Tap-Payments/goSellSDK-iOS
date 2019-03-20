//
//  Quantity.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Quantity model.
@objcMembers public final class Quantity: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    @available(swift, obsoleted: 1.0)
    @objc(unitOfMeasurement) public var measurement: _ObjCMeasurement {
        
        get {
            
            return _ObjCMeasurement.with(self.unitOfMeasurement)
        }
        set {
            
            self.unitOfMeasurement = newValue.swiftValue
        }
    }
    
    /// Unit of measurement.
    public var unitOfMeasurement: Measurement {
        
        didSet {
            
            self.updateAPIValues()
        }
    }
    
    /// Value.
    public var value: Decimal
    
    /// Measurement group.
    public var measurementGroup: String {
        
        return self.unitOfMeasurement.description
    }
    
    /// Measurement unit.
    public var measurementUnit: String {
        
        return Quantity.measurementUnitDescription(from: self.unitOfMeasurement)
    }
    
    // MARK: Methods
    
    /// Inititalizes quantity with unit of measurement and the value.
    ///
    /// - Parameters:
    ///   - value: Value.
    ///   - unitOfMeasurement: Unit of measurement.
    public init(value: Decimal, unitOfMeasurement: Measurement) {
        
        self.value = value
        self.unitOfMeasurement = unitOfMeasurement
        
        self.apiMeasurementGroup = unitOfMeasurement.description
        self.apiMeasurementUnit = Quantity.measurementUnitDescription(from: unitOfMeasurement)
        
        super.init()
    }
    
    /// Inititalizes quantity with unit of measurement and the value.
    ///
    /// - Parameters:
    ///   - value: Value.
    ///   - unitOfMeasurement: Unit of measurement.
    @available(swift, obsoleted: 1.0)
    public convenience init(value: Decimal, unitOfMeasurement: _ObjCMeasurement) {
        
        self.init(value: value, unitOfMeasurement: unitOfMeasurement.swiftValue)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case value                  = "value"
        case apiMeasurementGroup    = "measurement_group"
        case apiMeasurementUnit     = "measurement_unit"
    }
    
    // MARK: Properties
    
    private var apiMeasurementGroup: String
    private var apiMeasurementUnit: String
    
    // MARK: Methods
    
    private static func measurementUnitDescription(from measurement: Measurement) -> String {
        
        switch measurement {
            
        case .area              (let unit): return unit.description
        case .duration          (let unit): return unit.description
        case .electricCharge    (let unit): return unit.description
        case .electricCurrent   (let unit): return unit.description
        case .energy            (let unit): return unit.description
        case .length            (let unit): return unit.description
        case .mass              (let unit): return unit.description
        case .power             (let unit): return unit.description
        case .volume            (let unit): return unit.description
        case .units                       : return ""
            
        }
    }
    
    private func updateAPIValues() {
        
        self.apiMeasurementGroup = self.measurementGroup
        self.apiMeasurementUnit = self.measurementUnit
    }
}

// MARK: - NSCopying
extension Quantity: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Quantity(value: self.value, unitOfMeasurement: self.unitOfMeasurement)
    }
}

// MARK: - Decodable
extension Quantity: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let group   = try container.decode(String.self  , forKey: .apiMeasurementGroup)
        let unit    = try container.decode(String?.self , forKey: .apiMeasurementUnit)
        let value   = try container.decode(Decimal.self , forKey: .value)
        
        guard let measurement = Measurement(category: group, unit: unit) else {
            
            let userInfo = [
                
                ErrorConstants.UserInfoKeys.measurementCategory: group,
                ErrorConstants.UserInfoKeys.measurementUnit: unit ?? "null"
            ]
            
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidMeasurement.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
        
        self.init(value: value, unitOfMeasurement: measurement)
    }
}
