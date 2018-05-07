//
//  Quantity.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objcMembers public class Quantity: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unit of measurement.
    public let unitOfMeasurement: MeasurementUnit
    
    /// Value.
    public let value: Float
    
    // MARK: Methods
    
    /// Inititalizes quantity with unit of measurement and the value.
    ///
    /// - Parameters:
    ///   - value: Value.
    ///   - unitOfMeasurement: Unit of measurement.
    public init(value: Float, unitOfMeasurement: MeasurementUnit) {
        
        self.value = value
        self.unitOfMeasurement = unitOfMeasurement
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case unitOfMeasurement = "unit_of_measurement"
    }
}
