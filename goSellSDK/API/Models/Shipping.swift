//
//  Shipping.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Shipping data model class.
@objcMembers public class Shipping: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Shipping name.
    public var name: String
    
    /// Shipping description.
    public var descriptionText: String?
    
    /// Shipping amount.
    public var amount: Decimal
    
    // MARK: Methods
    
    /// Initializes `Shipping` model with the `name` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - amount: Shipping amount.
    public convenience init(name: String, amount: Decimal) {
        
        self.init(name: name, descriptionText: nil, amount: amount)
    }
    
    /// Initializes `Shipping` model with the `name`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - descriptionText: Shipping description.
    ///   - amount: Shipping amount.
    public init(name: String, descriptionText: String?, amount: Decimal) {
        
        self.name = name
        self.descriptionText = descriptionText
        self.amount = amount
        
        super.init()
    }
}
