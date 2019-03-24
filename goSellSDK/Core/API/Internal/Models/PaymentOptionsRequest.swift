//
//  PaymentOptionsRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct PaymentOptionsRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Transaction mode.
    internal let transactionMode: TransactionMode?
    
    /// Items to pay for.
    internal let items: [PaymentItem]?
    
    /// Items shippings.
    internal var shipping: [Shipping]?
    
    /// Taxes.
    internal var taxes: [Tax]?
    
    /// Items currency.
    internal let currency: Currency?
    
    /// Customer (payer).
    internal var customer: String?
    
    // MARK: Methods
	
	internal init(customer: String?) {
		
		self.init(transactionMode: nil, amount: nil, items: nil, shipping: nil, taxes: nil, currency: nil, customer: customer)
	}
	
	internal init(transactionMode:	TransactionMode?,
				  amount:			Decimal?,
				  items:			[PaymentItem]?,
				  shipping:			[Shipping]?,
				  taxes:			[Tax]?,
				  currency:			Currency?,
				  customer:			String?) {
        
        self.transactionMode    = transactionMode
        self.shipping           = shipping
        self.taxes              = taxes
        self.currency           = currency
        self.customer           = customer
		
		if let nonnullItems = items, nonnullItems.count > 0 {
			
			self.items = items
		}
		else {
			
			self.items = nil
		}
		
		self.totalAmount = Process.NonGenericAmountCalculator.totalAmount(of: items, with: taxes, and: shipping, plainAmount: amount)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case transactionMode    = "transaction_mode"
        case items              = "items"
        case shipping           = "shipping"
        case taxes              = "taxes"
        case currency           = "currency"
        case customer           = "customer"
        case totalAmount        = "total_amount"
    }
    
    // MARK: Properties
    
    private let totalAmount: Decimal
}

// MARK: - Encodable
extension PaymentOptionsRequest: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
		
        try container.encodeIfPresent(self.transactionMode, forKey: .transactionMode)
        try container.encodeIfPresent(self.items, forKey: .items)
        
        if self.shipping?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.shipping, forKey: .shipping)
        }
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes, forKey: .taxes)
        }
        
        try container.encodeIfPresent(self.currency, forKey: .currency)
        
        if self.customer?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.customer, forKey: .customer)
        }
		
		if self.totalAmount > 0.0 {
			
			try container.encodeIfPresent(self.totalAmount, forKey: .totalAmount)
		}
    }
}
