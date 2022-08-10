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
    public var descriptionText: ShippingDescription?
    
    /// Shipping recipientName.
    public var recipientName: String?
    
    /// Shipping amount.
    public var amount: Decimal
    
    /// Shipping address.
    public var address: Address?
    
    // MARK: Methods
    
    /// Initializes `Shipping` model with the `name` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - amount: Shipping amount.
    ///   - reciepntName: Shipping recipientName.
    ///   - address: Shipping address.
    public convenience init(name: String, amount: Decimal, recipientName:String? = "", address:Address? = nil) {
        
        self.init(name: name, descriptionText: nil, amount: amount, recipientName: recipientName, address: address)
    }
    
    /// Initializes `Shipping` model with the `name`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - descriptionText: Shipping description.
    ///   - amount: Shipping amount.
    ///   - reciepntName: Shipping recipientName.
    ///   - address: Shipping address.
    public init(name: String, descriptionText: ShippingDescription?, amount: Decimal, recipientName:String? = "", address:Address? = nil) {
        
        self.name               = name
        self.descriptionText    = descriptionText
        self.amount             = amount
        self.recipientName      = recipientName
        self.address            = address
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name               = "name"
        case descriptionText    = "description"
        case amount             = "amount"
        case recipientName      = "recipient_name"
        case address            = "address"
    }
}

// MARK: - NSCopying
extension Shipping: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Shipping(name: self.name, descriptionText: self.descriptionText?.copy() as? ShippingDescription, amount: self.amount, recipientName: self.recipientName, address: self.address?.copy() as? Address)
    }
}


/// Represents the shipping description model for the shipping
@objcMembers public class ShippingDescription: NSObject, Codable {
    
    @objc public init(en: String? = nil, ar: String? = nil) {
        self.en = en
        self.ar = ar
    }
    
    
    // Shipping en description.
    public var en: String?
    
    // Shipping ar description.
    public var ar: String?
    
    
    // Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return ShippingDescription(en: self.en, ar: self.ar)
    }
}
