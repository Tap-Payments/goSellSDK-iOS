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
    internal var items: [PaymentItem]?
    
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
    
    /// Reference.
    internal private(set) var reference: Reference?
    
    /// Order.
    internal private(set) var order: PaymentOptionsOrder?
    
    
    // MARK: Methods
	
	internal init(customer: String?) {
		
        self.init(transactionMode: nil, amount: nil, items: nil, shipping: nil, taxes: nil, currency: nil, merchantID: nil, customer: customer, destinationGroup: nil, paymentType: nil, topup:nil, reference:nil)
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
                  topup:            Topup?,
                  reference:        Reference?
		
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
        self.reference              = reference
        
		if let nonnullItems 		= items, nonnullItems.count > 0 {
			
			self.items = items
		}
		else {
			
			self.items = nil
		}
		
		self.totalAmount = Process.NonGenericAmountCalculator.totalAmount(of: items, with: taxes, and: shipping, plainAmount: amount)
        
        
        if self.items == nil,
           let nonNullAmount = amount {
            self.items = []
            // we will have to create a default item model here
            self.items?.append(.init(title: "Default item", quantity: 1, amountPerUnit: nonNullAmount, currency: currency))
        }
        
        self.order = .init(transactionMode: transactionMode, amount: self.totalAmount, items: self.items, shipping: self.shipping, taxes: self.taxes, currency: self.currency, merchantID: self.merchantID, customer: self.customer, destinationGroup: self.destinationGroup, paymentType: self.paymentType, topup: self.topup, reference: self.reference)
        // We will stop passing items in the payment options and pass it in order object only
        self.items = []
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
        case reference              = "reference"
        case order                  = "order"
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
        try container.encodeIfPresent(self.reference, forKey: .reference)
        try container.encodeIfPresent(self.order, forKey: .order)
        
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
