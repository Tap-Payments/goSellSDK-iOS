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
	
	/// Merchant ID.
	internal let merchantID: String?
	
    /// Customer (payer).
    internal var customer: String?
    
    /// Topup object if any
    internal let topup: Topup?
    
	/// List of destinations (grouped by "destination" key).
	internal private(set) var destinationGroup: DestinationGroup?
	
	/// Payment type.
	internal private(set) var paymentType: PaymentType?

    // MARK: Methods
	
	internal init(customer: String?) {
		
        self.init(transactionMode: nil, amount: nil, items: nil, shipping: nil, taxes: nil, currency: nil, merchantID: nil, customer: customer, destinationGroup: nil, paymentType: nil, topup:nil)
	}
	
	internal init(transactionMode:	TransactionMode?,
				  amount:			Decimal?,
				  items:			[PaymentItem]?,
				  shipping:			[Shipping]?,
				  taxes:			[Tax]?,
				  currency:			Currency?,
				  merchantID:		String?,
				  customer:			String?,
				  destinationGroup:	DestinationGroup?,
				  paymentType:		PaymentType?,
                  topup:            Topup?
		
	) {
        
        self.transactionMode    	= transactionMode
        self.shipping           	= shipping
        self.taxes              	= taxes
        self.currency           	= currency
		self.merchantID			    = merchantID
        self.customer           	= customer
		self.destinationGroup		= destinationGroup
		self.paymentType			= paymentType
        self.topup                  = topup
        
		if let nonnullItems 		= items, nonnullItems.count > 0 {
			
			self.items = items
		}
		else {
			
			self.items = nil
		}
		
		self.totalAmount = Process.NonGenericAmountCalculator.totalAmount(of: items, with: taxes, and: shipping, plainAmount: amount)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
		case transactionMode    	= "transaction_mode"
		case items              	= "items"
		case shipping           	= "shipping"
		case taxes              	= "taxes"
		case currency           	= "currency"
		case customer           	= "customer"
		case totalAmount        	= "total_amount"
		case merchantID			    = "merchant_id"
		case destinationGroup		= "destinations"
		case paymentType			= "payment_type"
        case topup                  = "topup"
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
        try container.encodeIfPresent(self.topup, forKey: .topup)
        try container.encodeIfPresent(self.items, forKey: .items)
        
        if self.shipping?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.shipping, forKey: .shipping)
        }
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes, forKey: .taxes)
        }
        
        try container.encodeIfPresent(self.currency, forKey: .currency)
		
		try container.encodeIfPresent(self.merchantID, forKey: .merchantID)
		
        if self.customer?.tap_length ?? 0 > 0 {
            
            try container.encodeIfPresent(self.customer, forKey: .customer)
        }
		
		if self.totalAmount > 0.0 {
			
			try container.encodeIfPresent(self.totalAmount, forKey: .totalAmount)
		}
        
        if self.destinationGroup?.destinations?.count ?? 0 > 0 {
               
               try container.encodeIfPresent(self.destinationGroup, forKey: .destinationGroup)
		}
		try container.encodeIfPresent(self.paymentType?.description.uppercased(), forKey: .paymentType)

           
    }
}
