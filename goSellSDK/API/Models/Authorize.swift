//
//  Authorize.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objcMembers public final class Authorize: NSObject, AuthorizeProtocol, IdentifiableWithString {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String
    
    /// Amount.
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    public let amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public let currency: Currency
    
    /// Customer.
    public let customer: CustomerInfo
    
    ///Flag indicating whether the object exists in live mode or test mode.
    public let isLiveMode: Bool
    
    /// Objects of the same type share the same value
    public let object: String
    
    /// Charge authentication if required.
    public private(set) var authentication: Authentication?
    
    /// Information related to the payment page redirect.
    public let redirect: TrackingURL
    
    /// Post URL.
    public private(set) var post: TrackingURL?
    
    /// The source of every charge is a credit or debit card. This hash is then the card object describing that card.
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_visamastercard" then Credit Card payment page link will be provided.
    public let source: Source
    
    /// Charge status.
    public let status: ChargeStatus
    
    /// Defines if 3D secure is required for the transaction.
    public let requires3DSecure: Bool
    
    /// Transaction details.
    public let transactionDetails: TransactionDetails
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public private(set) var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public private(set) var metadata: [String: String]?
    
    /// Charge reference.
    public private(set) var reference: Reference?
    
    /// Receipt settings.
    public private(set) var receiptSettings: Receipt?
    
    /// Charge response.
    public private(set) var response: Response?
    
    /// Extra information about a charge.
    /// This will appear on your customer’s credit card statement.
    /// It must contain at least one letter.
    public private(set) var statementDescriptor: String?
    
    /// Authorize action.
    public private(set) var authorizeAction: AuthorizeActionResponse
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case amount                 = "amount"
        case currency               = "currency"
        case customer               = "customer"
        case isLiveMode             = "live_mode"
        case object                 = "object"
        case authentication         = "authenticate"
        case redirect               = "redirect"
        case post                   = "post"
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
        case authorizeAction        = "auto"
    }
    
    // MARK: Methods
    
    private init(identifier: String, amount: Decimal, currency: Currency, customer: CustomerInfo, isLiveMode: Bool, object: String, authentication: Authentication?, redirect: TrackingURL, post: TrackingURL?, source: Source, status: ChargeStatus, requires3DSecure: Bool, transactionDetails: TransactionDetails, descriptionText: String?, metadata: [String: String]?, reference: Reference?, receiptSettings: Receipt?, response: Response?, statementDescriptor: String?, authorizeAction: AuthorizeActionResponse) {
        
        self.identifier             = identifier
        self.amount                 = amount
        self.currency               = currency
        self.customer               = customer
        self.isLiveMode             = isLiveMode
        self.object                 = object
        self.authentication         = authentication
        self.redirect               = redirect
        self.post                   = post
        self.source                 = source
        self.status                 = status
        self.requires3DSecure       = requires3DSecure
        self.transactionDetails     = transactionDetails
        self.descriptionText        = descriptionText
        self.metadata               = metadata
        self.reference              = reference
        self.receiptSettings        = receiptSettings
        self.response               = response
        self.statementDescriptor    = statementDescriptor
        self.authorizeAction        = authorizeAction
        
        super.init()
    }
}

// MARK: - Decodable
extension Authorize: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,                   forKey: .identifier)
        let amount              = try container.decode          (Decimal.self,                  forKey: .amount)
        let currency            = try container.decode          (Currency.self,                 forKey: .currency)
        let customer            = try container.decode          (CustomerInfo.self,             forKey: .customer)
        let isLiveMode          = try container.decode          (Bool.self,                     forKey: .isLiveMode)
        let object              = try container.decode          (String.self,                   forKey: .object)
        let authentication      = try container.decodeIfPresent (Authentication.self,           forKey: .authentication)
        let redirect            = try container.decode          (TrackingURL.self,              forKey: .redirect)
        let post                = try container.decodeIfPresent (TrackingURL.self,              forKey: .post)
        let source              = try container.decode          (Source.self,                   forKey: .source)
        let status              = try container.decode          (ChargeStatus.self,             forKey: .status)
        let requires3DSecure    = try container.decode          (Bool.self,                     forKey: .requires3DSecure)
        let transactionDetails  = try container.decode          (TransactionDetails.self,       forKey: .transactionDetails)
        let descriptionText     = try container.decodeIfPresent (String.self,                   forKey: .descriptionText)
        let metadata            = try container.decodeIfPresent ([String: String].self,         forKey: .metadata)
        let reference           = try container.decodeIfPresent (Reference.self,                forKey: .reference)
        let receiptSettings     = try container.decodeIfPresent (Receipt.self,                  forKey: .receiptSettings)
        let response            = try container.decodeIfPresent (Response.self,                 forKey: .response)
        let statementDescriptor = try container.decodeIfPresent (String.self,                   forKey: .statementDescriptor)
        let authorizeAction     = try container.decode          (AuthorizeActionResponse.self,  forKey: .authorizeAction)
        
        self.init(identifier:           identifier,
                  amount:               amount,
                  currency:             currency,
                  customer:             customer,
                  isLiveMode:           isLiveMode,
                  object:               object,
                  authentication:       authentication,
                  redirect:             redirect,
                  post:                 post,
                  source:               source,
                  status:               status,
                  requires3DSecure:     requires3DSecure,
                  transactionDetails:   transactionDetails,
                  descriptionText:      descriptionText,
                  metadata:             metadata,
                  reference:            reference,
                  receiptSettings:      receiptSettings,
                  response:             response,
                  statementDescriptor:  statementDescriptor,
                  authorizeAction:      authorizeAction)
    }
}

// MARK: - Authenticatable
extension Authorize: Authenticatable {
    
    internal static var authenticationRoute: Route { return .authorize }
}

// MARK: - Retrievable
extension Authorize: Retrievable {
    
    internal static var retrieveRoute: Route { return .authorize }
}
