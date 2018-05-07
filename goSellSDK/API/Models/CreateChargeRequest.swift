//
//  CreateChargeRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Create charge request model.
internal struct CreateChargeRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Amount.
    internal var amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    internal var currency: Currency
    
    /// Information related to the redirect.
    internal var redirect: Redirect
    
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_card" then Credit Card payment page link will be provided.
    /// if source.id = "Card Token ID or Card ID" then Credit Card payment processing page link will be provided.
    internal var source: Source?
    
    /// An arbitrary string to be displayed on your customer's credit card statement.
    /// This may be up to 22 characters.
    /// As an example, if your website is RunClub and the item you're charging for is a race ticket, you may want to specify a statement_descriptor of RunClub 5K race ticket.
    /// The statement description must contain at least one letter, may not include <>"' characters, and will appear on your customer's statement in capital letters.
    /// Non-ASCII characters are automatically stripped.
    /// While most banks and card issuers display this information consistently, some may display it incorrectly or not at all.
    internal var statementDescriptor: String?
    
    /// An arbitrary string which you can attach to a Charge object. It is displayed when in the web interface alongside the charge.
    internal var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    /// Individual keys can be unset by posting an empty value to them.
    /// All keys can be unset by posting an empty value to metadata.
    internal var metadata: [String: String]?
    
    /// The mobile number to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the mobile number specified here will override the customer's mobile number.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_sms is specified for a charge in live mode, a receipt will be sent regardless of your sms settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    internal var receiptSMS: String?
    
    /// The email address to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the email address specified here will override the customer's email address.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_email is specified for a charge in live mode, a receipt will be sent regardless of your email settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    internal var receiptEmail: String?
    
    // MARK: Methods
    
    /// Initializes charge request with all possible fields.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - redirect: Redirect object.
    ///   - source: Source object.
    ///   - statementDescriptor: Statement descriptor.
    ///   - descriptionText: Description.
    ///   - metadata: Metadata.
    ///   - receiptSMS: Receipt SMS.
    ///   - receiptEmail: Receipt email.
    internal init(amount: Decimal, currency: Currency, redirect: Redirect, source: Source? = nil, statementDescriptor: String? = nil, descriptionText: String? = nil, metadata: [String: String]? = nil, receiptSMS: String? = nil, receiptEmail: String? = nil) {
        
        self.amount = amount
        self.currency = currency
        self.source = source
        self.statementDescriptor = statementDescriptor
        self.redirect = redirect
        self.descriptionText = descriptionText
        self.metadata = metadata
        self.receiptSMS = receiptSMS
        self.receiptEmail = receiptEmail
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount = "amount"
        case currency = "currency"
        case source = "source"
        case statementDescriptor = "statement_descriptor"
        case redirect = "redirect"
        case descriptionText = "description"
        case metadata = "metadata"
        case receiptSMS = "receipt_sms"
        case receiptEmail = "receipt_email"
    }
}
