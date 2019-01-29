//
//  Shipping.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Shipping data model class.
@objcMembers public final class Shipping: NSObject, Codable {
    
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
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name               = "name"
        case descriptionText    = "description"
        case amount             = "amount"
    }
}

// MARK: - NSCopying
extension Shipping: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Shipping(name: self.name, descriptionText: self.descriptionText, amount: self.amount)
    }
}
