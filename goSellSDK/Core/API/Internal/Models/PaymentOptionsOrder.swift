//
//  PaymentOptionsOrder.swift
//  goSellSDK
//
//  Created by Osama Rabie on 10/08/2022.
//


internal struct PaymentOptionsOrder {
    
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Transaction mode.
    internal let transactionMode: TransactionMode?
    
    /// Items to pay for.
    internal let items: [PaymentItem]?
    
    /// Items shippings.
    internal var shipping: Shipping?
    
    /// Taxes.
    internal var taxes: [Tax]?
    
    /// Items currency.
    internal let currency: Currency?
    
    /// Merchant ID.
    internal let merchant: MerchantIDPaymentTypesOrder?
    
    /// Customer (payer).
    internal var customer: Customer?
    
    /// Topup object if any
    internal let topup: Topup?
    
    /// List of destinations (grouped by "destination" key).
    internal private(set) var destinationGroup: DestinationGroup?
    
    /// Payment type.
    internal private(set) var paymentType: PaymentType?
    
    /// Reference.
    internal private(set) var reference: Reference?
    
    
    // MARK: Methods
    
    internal init(customer: String) {
        
        self.init(transactionMode: nil, amount: 0, items: nil, shipping: nil, taxes: nil, currency: nil, merchantID: nil, customer: try! .init(identifier: customer), destinationGroup: nil, paymentType: nil, topup:nil, reference:nil)
    }
    
    internal init(transactionMode:    TransactionMode?,
                  amount:            Double,
                  items:            [PaymentItem]?,
                  shipping:            Shipping?,
                  taxes:            [Tax]?,
                  currency:            Currency?,
                  merchantID:        String?,
                  customer:            Customer?,
                  destinationGroup:    DestinationGroup?,
                  paymentType:        PaymentType?,
                  topup:            Topup?,
                  reference:        Reference?
                  
    ) {
        
        self.transactionMode        = transactionMode
        self.shipping               = shipping
        self.taxes                  = taxes
        self.currency               = currency
        self.merchant               = .init(id: merchantID)
        self.customer               = customer
        self.destinationGroup        = destinationGroup
        self.paymentType            = paymentType
        self.topup                  = topup
        self.reference              = reference
        
        if let nonnullItems         = items, nonnullItems.count > 0 {
            
            self.items = items
        }
        else {
            
            self.items = nil
        }
        
        self.totalAmount = amount
        
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case transactionMode        = "transaction_mode"
        case items                  = "items"
        case shipping               = "shipping"
        case taxes                  = "tax"
        case currency               = "currency"
        case customer               = "customer"
        case totalAmount            = "amount"
        case merchantID             = "merchant"
        case destinationGroup       = "destinations"
        case paymentType            = "payment_type"
        case topup                  = "topup"
        case reference              = "reference"
    }
    
    // MARK: Properties
    
    private let totalAmount: Double
}

// MARK: - Encodable
extension PaymentOptionsOrder: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.transactionMode, forKey: .transactionMode)
        try container.encodeIfPresent(self.topup, forKey: .topup)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encodeIfPresent(self.reference, forKey: .reference)
        try container.encodeIfPresent(self.shipping, forKey: .shipping)
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes, forKey: .taxes)
        }
        
        try container.encodeIfPresent(self.currency, forKey: .currency)
        
        try container.encodeIfPresent(self.merchant, forKey: .merchantID)
        
        try container.encodeIfPresent(self.customer, forKey: .customer)
        
        if self.totalAmount > 0.0 {
            
            try container.encodeIfPresent(self.totalAmount, forKey: .totalAmount)
        }
        
        if self.destinationGroup?.destinations?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.destinationGroup, forKey: .destinationGroup)
        }
        try container.encodeIfPresent(self.paymentType, forKey: .paymentType)
        
        
    }
}

/// The merchant model in order object for payment types
internal struct MerchantIDPaymentTypesOrder: Codable, Equatable {
    /// The merchant model in order object for payment types
    /// - Parameter id: The merchant id
    internal init(id: String?) {
        self.id = id
    }
    
    /// Merchant ID.
    internal let id: String?
    
    static func == (lhs: MerchantIDPaymentTypesOrder, rhs: MerchantIDPaymentTypesOrder) -> Bool {
        return lhs.id == rhs.id
    }
    
}
