//
//  SessionDataSource.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
import enum PassKit.PKPaymentButtonType
import enum PassKit.PKPaymentButtonStyle
import class PassKit.PKPaymentToken

/// Payment data source.
@objc public protocol SessionDataSource: class, NSObjectProtocol {
	
	/// Transaction mode.
	@objc optional var mode: TransactionMode { get }
    
    /// Provide a default card holder name to be written in the card input view
    @objc optional var cardHolderName: String? { get }
    
    /// Tells if the payer can change the card holder name, if there is no default card holder name stated this will be neglected
    @objc optional var cardHolderNameIsEditable: Bool { get }
	
	/// Details of the person who pays. Although the type is nullable, in order to start payment, customer should be nonnull.
	@objc var customer: Customer? { get }
    
    // /// Details if the merchant wants to start apple session
    //@objc optional var isApplePay: Bool { get }
    
    /// The apple pay merchanrt id registered in the Apple developer account. If not provided, the apple pay option will not be shown
    @objc optional var applePayMerchantID: String { get }
    
    // /// The type of the apple pay you want to show to user. By default it is 'Buy with Apple Pay'
   // @objc optional var applePayButtonType: PKPaymentButtonType { get }
    
    /// The type of the apple pay you want to show to user. By default it is 'White outline'
    @objc optional var applePayButtonStyle: PKPaymentButtonStyle { get }
    
   //  /// Details of the apple token data
    // @objc var appleTokenData: PKPaymentToken? { get }
    
	
	/// Transaction currency code. Although the type is nullable, in order to start payment, currency should be nonnull.
	@objc optional var currency: Currency? { get }
	
	/// Payment/Authorization amount.
	/// - Note: Either `amount` or `items` should be implemented. If both are implemented, `items` is preferred and amount is calculated from them.
	///         If `taxes` and/or `shipping` is implemented, it will affect the value you pass in this property.
	@objc optional var amount: Decimal { get }
	
	/// Items to pay for.
	/// - Note: Either `amount` or `items` should be implemented. If both are implemented, `items` are preferred and amount is calculated from them.
	///         If `taxes` and/or `shipping` is implemented, it will affect the amount which is calculated based on items you pass in this property.
	@objc optional var items: [PaymentItem]? { get }
	
	/// List of merchant desired destination accounts to receive money from payment transactions.
	@objc optional var destinations: [Destination]? { get }
	
	/// Merchant ID. Optional. Useful when you have multiple Tap accounts and would like to do the `switch` on the fly within the single app.
	@objc optional var merchantID: String? { get }
    
    /// Pay. iotinal string to pass if you want to show a different word for PAY, Save or Tokenize state on the button. This title will override the default values providede by TAP
    @objc optional var buttonTitle: String? { get }
    
    /// Decides if to show the amount inside the checkout pay button beside the title. Default is true
    @objc optional var showAmountOnPayButton: Bool { get }
    
	/// Taxes.
	@objc optional var taxes: [Tax]? { get }
    
    /// allowed Card Types, if not set all will be accepeted.
    @objc optional var allowedCadTypes: [CardType]? { get }
	
	/// Shipping options.
	@objc optional var shipping: [Shipping]? { get }
	
	/// Post URL. The URL that will be called by Tap system notifying that payment has succeed or failed.
	@objc optional var postURL: URL? { get }
	
	/// Description of the payment.
	@objc optional var paymentDescription: String? { get }
	
	/// Additional information you would like to pass along with the transaction.
	@objc optional var paymentMetadata: Metadata? { get }
	
	/// Payment reference. Implement this property to keep a reference to the transaction on your backend.
	@objc optional var paymentReference: Reference? { get }
	
	/// Payment statement descriptor.
	@objc optional var paymentStatementDescriptor: String? { get }
	
	/// Defines if 3D secure check is required.
	@objc optional var require3DSecure: Bool { get }
	
	/// Receipt dispatch settings.
	@objc optional var receiptSettings: Receipt? { get }
	
	/// Action to perform after authorization succeeds.
	@objc optional var authorizeAction: AuthorizeAction { get }
	
	/// Defines if same card can be saved more than once.
	/// Default is `true`.
	@objc optional var allowsToSaveSameCardMoreThanOnce: Bool { get }
    
    
    /// Defines if the customer can save his card for upcoming payments
    /// Default is `true`.
    @objc optional var enableSaveCard: Bool { get }
	
	/// Defines if save card switch is on by default.
	/// - Note: If value of this property is `true`, then switch will be remaining off until card information is filled and valid.
	///         And after will be toggled on automatically.
	@objc optional var isSaveCardSwitchOnByDefault: Bool { get }
	
	/// Defines the required payments `web` or  `card`
	@objc optional var paymentType: PaymentType { get }
    
    /// Defines the topup module if needed
    @objc optional var topup: Topup { get }

}
