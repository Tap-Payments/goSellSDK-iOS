//
//  PaymentItem.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment item model.
@objcMembers public final class PaymentItem: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Payment item title.
    public var title: String
    
    /// Payment item description text.
    public var descriptionText: String?
    
    /// Quantity of payment item(s).
    public var quantity: Quantity {
        
        didSet {
            
            self.updateTotalAmount()
        }
    }
    
    /// Amount per a single unit of quantity.
    public var amountPerUnit: Decimal {
        
        didSet {
            
            self.updateTotalAmount()
        }
    }
    
    /// Item(s) discount.
    public var discount: AmountModificator? {
        
        didSet {
            
            self.updateTotalAmount()
        }
    }
    
    /// Items(s) taxes.
    public var taxes: [Tax]? {
        
        didSet {
            
            self.updateTotalAmount()
        }
    }
    
    // MARK: Methods
    
    /// Initializes payment item with title, quantity and amount per unit.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public convenience init(title: String, quantity: Quantity, amountPerUnit: Decimal) {
        
        self.init(title: title, descriptionText: nil, quantity: quantity, amountPerUnit: amountPerUnit)
    }
    
    /// Initializes payment item with title, quantity, units of measurement and amount per unit.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal) {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: nil)
    }
    
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?) {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: nil)
    }
    
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, taxes: [Tax]?) {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: nil, taxes: taxes)
    }
    
    public required init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?, taxes: [Tax]?) {
        
        self.title = title
        self.descriptionText = descriptionText
        self.quantity = quantity
        self.amountPerUnit = amountPerUnit
        self.discount = discount
        self.taxes = taxes
        self.totalAmount = PaymentItem.calculateTotalAmount(with: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: taxes)
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var totalAmount: Decimal
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case title              = "name"
        case descriptionText    = "description"
        case quantity           = "quantity"
        case amountPerUnit      = "amount_per_unit"
        case discount           = "discount"
        case taxes              = "taxes"
        case totalAmount        = "total_amount"
    }
    
    // MARK: Methods
    
    private static func calculateTotalAmount(with quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?, taxes: [Tax]?) -> Decimal {
        
        return 0.0
    }
    
    private func updateTotalAmount() {
        
        self.totalAmount = PaymentItem.calculateTotalAmount(with: self.quantity, amountPerUnit: self.amountPerUnit, discount: self.discount, taxes: self.taxes)
    }
}

// MARK: - NSCopying
extension PaymentItem: NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let quantityCopy = self.quantity.copy() as! Quantity
        let discountCopy = self.discount?.copy() as? AmountModificator
        let taxesCopy = self.taxes?.compactMap { $0.copy() as? Tax }
        
        return PaymentItem(title: self.title,
                           descriptionText: self.descriptionText,
                           quantity: quantityCopy,
                           amountPerUnit: self.amountPerUnit,
                           discount: discountCopy,
                           taxes: taxesCopy)
    }
}
