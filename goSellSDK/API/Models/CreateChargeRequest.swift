//
//  CreateChargeRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Create charge request model.
internal class CreateChargeRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Amount.
    internal let amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    internal let currency: Currency
    
    /// Customer information.
    internal let customer: CustomerInfo
    
    /// Fees amount.
    internal let fee: Decimal
    
    /// Order.
    internal let order: Order
    
    /// Redirect URL.
    internal let redirect: TrackingURL
    
    /// Post URL.
    internal private(set) var post: TrackingURL?
    
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_card" then Credit Card payment page link will be provided.
    /// if source.id = "Card Token ID or Card ID" then Credit Card payment processing page link will be provided.
    internal let source: Source
    
    /// An arbitrary string which you can attach to a Charge object. It is displayed when in the web interface alongside the charge.
    internal private(set) var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    /// Individual keys can be unset by posting an empty value to them.
    /// All keys can be unset by posting an empty value to metadata.
    internal private(set) var metadata: [String: String]?
    
    /// Merchant reference object.
    internal private(set) var reference: Reference?
    
    /// Defines whether the card should be saved.
    internal private(set) var shouldSaveCard: Bool
    
    /// An arbitrary string to be displayed on your customer's credit card statement.
    /// This may be up to 22 characters.
    /// As an example, if your website is RunClub and the item you're charging for is a race ticket, you may want to specify a statement_descriptor of RunClub 5K race ticket.
    /// The statement description must contain at least one letter, may not include <>"' characters, and will appear on your customer's statement in capital letters.
    /// Non-ASCII characters are automatically stripped.
    /// While most banks and card issuers display this information consistently, some may display it incorrectly or not at all.
    internal private(set) var statementDescriptor: String?
    
    /// Defines if 3d secure is required for this transaction. Default is `true`.
    internal private(set) var requires3DSecure: Bool?
    
    /// Receipt settings.
    internal private(set) var receipt: Receipt?
    
    // MARK: Methods
    
    /// Initializes charge request.
    ///
    /// - Parameters:
    ///   - amount: Charge amount.
    ///   - currency: Charge currency.
    ///   - customer: Customer.
    ///   - fee: Extra fees amount.
    ///   - order: Order.
    ///   - redirect: Redirect.
    ///   - post: Post.
    ///   - source: Source.
    ///   - descriptionText: Description text.
    ///   - metadata: Metadata.
    ///   - reference: Reference.
    ///   - shouldSaveCard: Defines if the card should be saved.
    ///   - statementDescriptor: Statement descriptor.
    ///   - requires3DSecure: Defines if 3D secure is required.
    ///   - receipt: Receipt settings.
    internal init(amount: Decimal, currency: Currency, customer: CustomerInfo, fee: Decimal, order: Order, redirect: TrackingURL, post: TrackingURL?, source: Source, descriptionText: String?, metadata: [String: String]?, reference: Reference?, shouldSaveCard: Bool, statementDescriptor: String?, requires3DSecure: Bool?, receipt: Receipt?) {
        
        self.amount                 = amount
        self.currency               = currency
        self.customer               = customer
        self.fee                    = fee
        self.order                  = order
        self.redirect               = redirect
        self.post                   = post
        self.source                 = source
        self.descriptionText        = descriptionText
        self.metadata               = metadata
        self.reference              = reference
        self.shouldSaveCard         = shouldSaveCard
        self.statementDescriptor    = statementDescriptor
        self.requires3DSecure       = requires3DSecure
        self.receipt                = receipt
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount                 = "amount"
        case currency               = "currency"
        case customer               = "customer"
        case fee                    = "fee"
        case order                  = "order"
        case redirect               = "redirect"
        case post                   = "post"
        case source                 = "source"
        case descriptionText        = "description"
        case metadata               = "metadata"
        case reference              = "reference"
        case shouldSaveCard         = "save_card"
        case statementDescriptor    = "statement_descriptor"
        case requires3DSecure       = "threeDSecure"
        case receipt                = "receipt"
    }
}
