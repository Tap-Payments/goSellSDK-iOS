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
    
    /// Shipping provider.
    public var provider: ShippingProvider?
    
    // MARK: Methods
    
    /// Initializes `Shipping` model with the `name` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - amount: Shipping amount.
    ///   - reciepntName: Shipping recipientName.
    ///   - address: Shipping address.
    ///   - provider: Shipping provider
    public convenience init(name: String, amount: Decimal, recipientName:String? = "", address:Address? = nil, provider:ShippingProvider? = nil) {
        
        self.init(name: name, descriptionText: nil, amount: amount, recipientName: recipientName, address: address, provider: provider)
    }
    
    /// Initializes `Shipping` model with the `name`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - descriptionText: Shipping description.
    ///   - amount: Shipping amount.
    ///   - reciepntName: Shipping recipientName.
    ///   - address: Shipping address.
    ///   - provider: Shipping provider
    public init(name: String, descriptionText: ShippingDescription?, amount: Decimal, recipientName:String? = "", address:Address? = nil, provider:ShippingProvider? = nil) {
        
        self.name               = name
        self.descriptionText    = descriptionText
        self.amount             = amount
        self.recipientName      = recipientName
        self.address            = address
        self.provider           = provider
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name               = "name"
        case descriptionText    = "description"
        case amount             = "amount"
        case recipientName      = "recipient_name"
        case address            = "address"
        case provider           = "provider"
    }
}

// MARK: - NSCopying
extension Shipping: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Shipping(name: self.name, descriptionText: self.descriptionText?.copy() as? ShippingDescription, amount: self.amount, recipientName: self.recipientName, address: self.address?.copy() as? Address, provider: self.provider?.copy() as? ShippingProvider)
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




/// Represents the shipping provider model for the shipping
@objcMembers public class ShippingProvider: NSObject, Codable {
    
    @objc public init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    
    // provider id
    public var id: String?
    
    // provider name
    public var name: String?
    
    
    // Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return ShippingProvider(id: self.id, name: self.name)
    }
}
