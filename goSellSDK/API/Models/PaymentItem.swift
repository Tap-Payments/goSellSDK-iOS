//
//  PaymentItem.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment item model.
@objcMembers public class PaymentItem: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Payment item title.
    public let title: String
    
    /// Payment item description.
    public var itemDescription: String?
    
    /// Quantity of payment item(s).
    public let quantity: Quantity
    
    /// Amount per a single unit of quantity.
    public let amountPerUnit: Decimal
    
    // MARK: Methods
    
    /// Initializes payment item with title, quantity, units of measurement and amount per unit.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - quantity: Payment item's quantity.
    ///   - unitsOfMeasurement: Units of measurement.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public convenience init(title: String, quantity: Float, unitsOfMeasurement: MeasurementUnit, amountPerUnit: Decimal) {
        
        self.init(title: title, description: nil, quantity: quantity, unitsOfMeasurement: unitsOfMeasurement, amountPerUnit: amountPerUnit)
    }
    
    /// Initializes payment item with title, quantity, units of measurement and amount per unit.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - description: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - unitsOfMeasurement: Units of measurement.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public init(title: String, description: String?, quantity: Float, unitsOfMeasurement: MeasurementUnit, amountPerUnit: Decimal) {
        
        self.title = title
        self.itemDescription = description
        self.quantity = Quantity(value: quantity, unitOfMeasurement: unitsOfMeasurement)
        self.amountPerUnit = amountPerUnit
        self.totalAmount = amountPerUnit * Decimal(floatLiteral: Double(quantity))
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let totalAmount: Decimal
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case title = "name"
        case itemDescription = "description"
        case quantity = "quantity"
        case amountPerUnit = "amount"
        case totalAmount = "total_amount"
    }
}
