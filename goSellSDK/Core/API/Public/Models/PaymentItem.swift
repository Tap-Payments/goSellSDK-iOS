//
//  PaymentItem.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Payment item model.
@objcMembers public final class PaymentItem: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Payment item title.
    public var title: String
    
    /// Payment item description text.
    public var descriptionText: String?
    
    /// Quantity of payment item(s).
    public var quantity: Quantity
    
    /// Amount per a single unit of quantity.
    public var amountPerUnit: Decimal
    
    /// Item(s) discount.
    public var discount: AmountModificator?
    
    /// Items(s) taxes.
    public var taxes: [Tax]?
    
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
    
    /// Initializes payment item with title, description, quantity and amount per unit.
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
    
    /// Initializes payment item with title, description, quantity, amount per unit and discount.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - discount: Payment item's discount.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value - discount`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?) {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: nil)
    }
    
    /// Initializes payment item with title, description, quantity, amount per unit and taxes.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - taxes: Payment item's taxes.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value + taxes`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, taxes: [Tax]?) {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: nil, taxes: taxes)
    }
    
    /// Initializes payment item with title, description, quantity, amount per unit, discount and taxes.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - discount: Payment item's discount.
    ///   - taxes: Payment item's taxes.
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value - discount + taxes`
    public required init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?, taxes: [Tax]?) {
        
        self.title = title
        self.descriptionText = descriptionText
        self.quantity = quantity
        self.amountPerUnit = amountPerUnit
        self.discount = discount
        self.taxes = taxes
        
        super.init()
    }
    
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
}

// MARK: - Encodable
extension PaymentItem: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.title            , forKey: .title            )
        
        if self.descriptionText?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.descriptionText, forKey: .descriptionText)
        }
        
        try container.encodeIfPresent(self.quantity         , forKey: .quantity         )
        try container.encodeIfPresent(self.amountPerUnit    , forKey: .amountPerUnit    )
        
        try container.encodeIfPresent(self.discount         , forKey: .discount         )
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes        , forKey: .taxes            )
        }
        
        try container.encodeIfPresent(self.totalItemAmount  , forKey: .totalAmount      )
    }
}

// MARK: - Decodable
extension PaymentItem: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        
        let title           = try container.decode          (String.self            , forKey: .title            )
        let descriptionText = try container.decodeIfPresent (String.self            , forKey: .descriptionText  )
        let quantity        = try container.decode          (Quantity.self          , forKey: .quantity         )
        let amountPerUnit   = try container.decode          (Decimal.self           , forKey: .amountPerUnit    )
        let discount        = try container.decodeIfPresent (AmountModificator.self , forKey: .discount         )
        let taxes           = try container.decodeIfPresent ([Tax].self             , forKey: .taxes            )
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: taxes)
    }
}

// MARK: - NSCopying
extension PaymentItem: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
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
