//
//  Charge.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Charge model.
/// To charge a credit or a debit card, you create a charge object.
/// You can retrieve and refund individual charges as well as list all charges.
/// Charges are identified by a unique random ID.
internal struct Charge: Decodable, Identifiable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    internal private(set) var identifier: String?
    
    /// Amount.
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    internal let amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    internal let currency: Currency
    
    /// Customer.
    internal let customer: CustomerInfo
    
    ///Flag indicating whether the object exists in live mode or test mode.
    internal let isLiveMode: Bool
    
    /// Objects of the same type share the same value
    internal let object: String
    
    /// Information related to the payment page redirect.
    internal let redirect: Redirect
    
    /// The source of every charge is a credit or debit card. This hash is then the card object describing that card.
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_visamastercard" then Credit Card payment page link will be provided.
    internal let source: Source
    
    /// Charge status.
    internal let status: ChargeStatus
    
    /// Defines if 3D secure is required for the transaction.
    internal let requires3DSecure: Bool
    
    /// Transaction details.
    internal let transactionDetails: TransactionDetails
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    internal private(set) var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    internal private(set) var metadata: [String: String]?
    
    /// Charge reference.
    internal private(set) var reference: Reference?
    
    /// Receipt settings.
    internal private(set) var receiptSettings: Receipt?
    
    /// Charge response.
    internal private(set) var response: Response?
    
    /// Extra information about a charge.
    /// This will appear on your customer’s credit card statement.
    /// It must contain at least one letter.
    internal private(set) var statementDescriptor: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case amount                 = "amount"
        case currency               = "currency"
        case customer               = "customer"
        case isLiveMode             = "live_mode"
        case object                 = "object"
        case redirect               = "redirect"
        case source                 = "source"
        case status                 = "status"
        case requires3DSecure       = "threeDSecure"
        case transactionDetails     = "transaction"
        case descriptionText        = "description"
        case metadata               = "metadata"
        case reference              = "reference"
        case receiptSettings        = "receipt"
        case response               = "response"
        case statementDescriptor    = "statement_descriptor"
    }
}
