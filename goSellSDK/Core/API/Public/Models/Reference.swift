//
//  Reference.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Reference object.
@objcMembers public final class Reference: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Acquirer reference.
    public private(set) var acquirer: String?
    
    /// Gateway reference.
    public private(set) var gatewayReference: String?
    
    /// Payment reference.
    public private(set) var paymentReference: String?
    
    /// Tracking number.
    public private(set) var trackingNumber: String?
    
    /// Merchant transaction reference number.
    public var transactionNumber: String?
    
    /// Merchant order number.
    public var orderNumber: String?
    
    public var gosellID: String?
    
    // MARK: Methods
    
    /// Initializes reference object with transaction number and order number.
    ///
    /// - Parameters:
    ///   - transactionNumber: Merchant transaction reference number.
    ///   - orderNumber: Merchant order number.
    public init(transactionNumber: String? = nil, orderNumber: String? = nil) {
        
        self.transactionNumber = transactionNumber
        self.orderNumber = orderNumber
        
        super.init()
    }
    
    // MARK: - Private
    
    private enum CodingKeys: String, CodingKey {
        
        case acquirer           = "acquirer"
        case gatewayReference   = "gateway"
        case paymentReference   = "payment"
        case trackingNumber     = "track"
        case transactionNumber  = "transaction"
        case orderNumber        = "order"
        case gosellID           = "gosell_id"
    }
}
