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
    public let unitOfMeasurement: Measurement
    
    /// Value.
    public let value: Decimal
    
    // MARK: Methods
    
    /// Inititalizes quantity with unit of measurement and the value.
    ///
    /// - Parameters:
    ///   - value: Value.
    ///   - unitOfMeasurement: Unit of measurement.
    public init(value: Decimal, unitOfMeasurement: Measurement) {
        
        self.value = value
        self.unitOfMeasurement = unitOfMeasurement
        self.measurementGroup = unitOfMeasurement.description
        
        switch unitOfMeasurement {
            
        case .area(let unit):   self.measurementUnit = unit.description
        case .length(let unit): self.measurementUnit = unit.description
        case .mass(let unit):   self.measurementUnit = unit.description
        case .units:            self.measurementUnit = "units"

        }
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let measurementGroup: String
    internal let measurementUnit: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case measurementGroup = "measurement_group"
        case measurementUnit = "measurement_unit"
    }
}
