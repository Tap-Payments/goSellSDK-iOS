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
    internal var shipping: Shipping?
    
    /// Taxes.
    internal var taxes: [Tax]?
    
    /// Items currency.
    internal let currency: Currency?
	
	/// Merchant ID.
	internal let merchantID: String?
	
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
    
    /// Order.
    internal private(set) var order: PaymentOptionsOrder?
    
    
    // MARK: Methods
	
    internal init(customer: Customer?) {
        
        self.init(transactionMode: nil, amount: nil, items: nil, shipping: nil, taxes: nil, currency: nil, merchantID: nil, customer: customer, destinationGroup: nil, paymentType: .all, topup:nil, reference:nil)
    }
	
	internal init(transactionMode:	TransactionMode?,
				  amount:			Decimal?,
				  items:			[PaymentItem]?,
				  shipping:			Shipping?,
				  taxes:			[Tax]?,
				  currency:			Currency?,
				  merchantID:		String?,
				  customer:			Customer?,
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
        var shippingArray:[Shipping] = []
        if let nonNullShipping = self.shipping {
            shippingArray = [nonNullShipping]
        }
		self.totalAmount = Process.NonGenericAmountCalculator.totalAmount(of: items, with: taxes, and: shippingArray, plainAmount: amount)
        
        
        if self.items == nil,
           let nonNullAmount = amount {
            self.items = []
            // we will have to create a default item model here
            self.items?.append(.init(title: "Default item", quantity: 1, amountPerUnit: nonNullAmount, currency: currency))
        }
        
        
        // Create the order object with the payment options request data
        self.order = .init(transactionMode: self.transactionMode, amount: NSDecimalNumber(decimal:self.totalAmount).doubleValue, items: self.items, shipping: self.shipping, taxes: self.taxes, currency: self.currency, merchantID: self.merchantID, customer: self.customer, destinationGroup: self.destinationGroup, paymentType: self.paymentType, topup: self.topup, reference: self.reference)
        // We will stop passing items in the payment options and pass it in order object only
        self.items = []
        // We will not be sending customr info in the payment types anymore
        self.customer = nil
        // We will not be sending shipping info in the payment types anymore
        self.shipping = nil
        // We will not be sending tax info in the payment types anymore
        self.taxes = nil
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
        try container.encodeIfPresent(self.paymentType?.description.uppercased(), forKey: .paymentType)
        try container.encodeIfPresent(self.shipping, forKey: .shipping)
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes, forKey: .taxes)
        }
        
        try container.encodeIfPresent(self.currency, forKey: .currency)
		
		try container.encodeIfPresent(self.merchantID, forKey: .merchantID)
		
        if let customer:Customer = self.customer {
            // Check if we need to pass ONLY the customer ID of the full customer object
            if let customerID = customer.identifier {
                try container.encode(customerID, forKey: .customer)
            }else{
                try container.encodeIfPresent(customer, forKey: .customer)
            }
        }
		
		if self.totalAmount > 0.0 {
			
			try container.encodeIfPresent(self.totalAmount, forKey: .totalAmount)
		}
        
        if self.destinationGroup?.destinations?.count ?? 0 > 0 {
               
               try container.encodeIfPresent(self.destinationGroup, forKey: .destinationGroup)
		}
           
    }
}
