//
//  ChargeProtocol.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol ChargeProtocol: Authenticatable, Retrievable {
    
    /// API version.
    var apiVersion: String { get }
    
    /// Amount.
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    var amount: Decimal { get }
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    var currency: Currency { get }
    
    /// Customer.
    var customer: Customer { get }
	
    /// Flag indicating whether the object exists in live mode or test mode.
    var isLiveMode: Bool { get }
    
    /// Defines if the card used in transaction was saved.
    var cardSaved: Bool { get }
    
    /// Objects of the same type share the same value
    var object: String { get }
    
    /// Information related to the payment page redirect.
    var redirect: TrackingURL { get }
    
    /// Post URL.
    var post: TrackingURL? { get }
    
    /// Saved card. Available only with card payment.
    var card: SavedCard? { get }
    
    /// Charge source.
    var source: Source { get }
	
	/// Charge destinations.
	var destinations: DestinationGroup? { get }
	
    /// Charge status.
    var status: ChargeStatus { get set }
    
    /// Defines if 3D secure is required for the transaction.
    var requires3DSecure: Bool { get }
    
    /// Transaction details.
    var transactionDetails: TransactionDetails { get }
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    var descriptionText: String? { get }
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    var metadata: Metadata? { get }
    
    /// Charge reference.
    var reference: Reference? { get }
    
    /// Receipt settings.
    var receiptSettings: Receipt? { get }
    
    /// Acquirer information.
    var acquirer: Acquirer? { get }
    
    /// Charge response.
    var response: Response? { get }
    
    /// Extra information about a charge.
    /// This will appear on your customer’s credit card statement.
    /// It must contain at least one letter.
    var statementDescriptor: String? { get }
}
