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
    
    /// Payment item id
    public var productID: String?
    
    /// Payment item fulfillment_service
    public var fulfillmentService: String?
    
    /// Payment item category
    public var category: String?
    
    /// Payment item code
    public var itemCode: String?
    
    /// Payment item shiping
    public var requiresShipping: Bool
    
    /// Quantity of payment item(s).
    public var quantity: Quantity
    
    /// The item's vendor
    public var vendor: Vendor?
    
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
    ///   - productID: The product id
    ///   - category: The product category
    /// Payment item fulfillment_service
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public convenience init(title: String, quantity: Quantity, amountPerUnit: Decimal, productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "") {
        
        self.init(title: title, descriptionText: nil, quantity: quantity, amountPerUnit: amountPerUnit, category: category, vendor: vendor, fulfillmentService: fulfillmentService, requiresShipping: requiresShipping, itemCode: itemCode)
    }
    
    /// Initializes payment item with title, description, quantity and amount per unit.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - productID: The product id
    ///   - category: The product category
    /// Payment item fulfillment_service
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "") {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: nil, category: category, vendor: vendor, fulfillmentService: fulfillmentService, requiresShipping: requiresShipping, itemCode: itemCode)
    }
    
    /// Initializes payment item with title, description, quantity, amount per unit and discount.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - discount: Payment item's discount.
    ///   - productID: The product id
    ///   - category: The product category
    /// Payment item fulfillment_service
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value - discount`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?, productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "") {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: nil, category: category, vendor: vendor, fulfillmentService: fulfillmentService, requiresShipping: requiresShipping, itemCode: itemCode)
    }
    
    /// Initializes payment item with title, description, quantity, amount per unit and taxes.
    ///
    /// - Parameters:
    ///   - title: Payment item's title.
    ///   - descriptionText: Item description.
    ///   - quantity: Payment item's quantity.
    ///   - amountPerUnit: Amount per a single unit of quantity.
    ///   - taxes: Payment item's taxes.
    ///   - productID: The product id
    ///   - category: The product category
    /// Payment item fulfillment_service
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value + taxes`
    public convenience init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, taxes: [Tax]?, productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "") {
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: nil, taxes: taxes, category: category, vendor: vendor, fulfillmentService: fulfillmentService, requiresShipping: requiresShipping, itemCode: itemCode)
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
    ///   - productID: The product id
    ///   - category: The product category
    /// Payment item fulfillment_service
    /// - Attention: Total amount of the payment item is calculated with the following formula: `amountPerUnit * quantity.value - discount + taxes`
    public required init(title: String, descriptionText: String?, quantity: Quantity, amountPerUnit: Decimal, discount: AmountModificator?, taxes: [Tax]?, productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "") {
        
        self.title = title
        self.descriptionText = descriptionText
        self.quantity = quantity
        self.amountPerUnit = amountPerUnit
        self.discount = discount
        self.taxes = taxes
        self.productID = productID
        self.category = category
        self.fulfillmentService = fulfillmentService
        self.vendor = vendor
        self.requiresShipping = requiresShipping
        self.itemCode = itemCode
        
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
        case productID          = "product_id"
        case category           = "category"
        case vendor             = "vendor"
        case fulfillmentService = "fulfillment_service"
        case requiresShipping   = "requires_shipping"
        case itemCode           = "item_code"
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
        
        
        if self.category?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.category, forKey: .category)
        }
        
        if self.productID?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.productID, forKey: .productID)
        }
        
        if self.fulfillmentService?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.fulfillmentService, forKey: .fulfillmentService)
        }
        
        
        if self.itemCode?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.itemCode, forKey: .itemCode)
        }
        
        try container.encodeIfPresent(self.requiresShipping           , forKey: .requiresShipping           )
        
        try container.encodeIfPresent(self.vendor           , forKey: .vendor           )
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
        let productID       = try container.decodeIfPresent (String.self            , forKey: .productID        )
        let itemCode       = try container.decodeIfPresent (String.self            , forKey: .itemCode        )
        let requiresShipping = try container.decodeIfPresent (Bool.self            , forKey: .requiresShipping        ) ?? false
        let fulfillmentService = try container.decodeIfPresent (String.self            , forKey: .fulfillmentService        )
        let category        = try container.decodeIfPresent (String.self            , forKey: .category         )
        let vendor          = try container.decodeIfPresent (Vendor.self            , forKey: .vendor           )
        let quantity        = try container.decode          (Quantity.self          , forKey: .quantity         )
        let amountPerUnit   = try container.decode          (Decimal.self           , forKey: .amountPerUnit    )
        let discount        = try container.decodeIfPresent (AmountModificator.self , forKey: .discount         )
        let taxes           = try container.decodeIfPresent ([Tax].self             , forKey: .taxes            )
        
        self.init(title: title, descriptionText: descriptionText, quantity: quantity, amountPerUnit: amountPerUnit, discount: discount, taxes: taxes, productID: productID, category: category, vendor: vendor, fulfillmentService: fulfillmentService, requiresShipping: requiresShipping, itemCode: itemCode)
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
        let vendorCopy = self.vendor?.copy() as? Vendor
        let taxesCopy = self.taxes?.compactMap { $0.copy() as? Tax }
        
        return PaymentItem(title: self.title,
                           descriptionText: self.descriptionText,
                           quantity: quantityCopy,
                           amountPerUnit: self.amountPerUnit,
                           discount: discountCopy,
                           taxes: taxesCopy,
                           productID: self.productID,
                           category: self.category,
                           vendor: vendorCopy,
                           fulfillmentService: self.fulfillmentService,
                           requiresShipping: requiresShipping,
                           itemCode: itemCode)
    }
}


/// The products vendor model
@objcMembers public class Vendor: NSObject, Codable {
    
    @objc public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Payment item title.
    @objc public var id: String
    
    /// Payment item description text.
    @objc public var name: String
    
    // MARK: - NSCopying
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        return Vendor(id: self.id, name: self.name)
    }
}
