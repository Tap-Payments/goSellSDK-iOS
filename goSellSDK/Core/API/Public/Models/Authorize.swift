//
//  Authorize.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Authorize object.
@objcMembers public final class Authorize: NSObject, AuthorizeProtocol, IdentifiableWithString {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String
    
    /// API version.
    public let apiVersion: String
    
    /// Amount.
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    public let amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public let currency: Currency
    
    /// Customer.
    public let customer: Customer
    
    ///Flag indicating whether the object exists in live mode or test mode.
    public let isLiveMode: Bool
    
    /// Defines if the card used in transaction was saved.
    public let cardSaved: Bool
    
    /// Objects of the same type share the same value
    public let object: String
    
    /// Charge authentication if required.
    public private(set) var authentication: Authentication?
    
    /// Information related to the payment page redirect.
    public let redirect: TrackingURL
    
    /// Post URL.
    public private(set) var post: TrackingURL?
    
    /// Saved card.
    public private(set) var card: SavedCard?
    
    /// Authorize source.
    public let source: Source
	
	/// List of destinations.
	public private(set) var destinations: DestinationGroup?
	
    /// Charge status.
    public var status: ChargeStatus
    
    /// Defines if 3D secure is required for the transaction.
    public let requires3DSecure: Bool
    
    /// Transaction details.
    public let transactionDetails: TransactionDetails
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public private(set) var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public private(set) var metadata: Metadata?
    
    /// Charge reference.
    public private(set) var reference: Reference?
    
    /// Receipt settings.
    public private(set) var receiptSettings: Receipt?
    
    /// Acquirer information.
    public private(set) var acquirer: Acquirer?
    
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
        case apiVersion             = "api_version"
        case amount                 = "amount"
        case currency               = "currency"
        case customer               = "customer"
        case isLiveMode             = "live_mode"
        case cardSaved              = "save_card"
        case object                 = "object"
        case authentication         = "authenticate"
        case redirect               = "redirect"
        case post                   = "post"
        case card                   = "card"
        case source                 = "source"
		case destinations			= "destinations"
        case status                 = "status"
        case requires3DSecure       = "threeDSecure"
        case transactionDetails     = "transaction"
        case descriptionText        = "description"
        case metadata               = "metadata"
        case reference              = "reference"
        case receiptSettings        = "receipt"
        case acquirer               = "acquirer"
        case response               = "response"
        case statementDescriptor    = "statement_descriptor"
        case authorizeAction        = "auto"
    }
    
    // MARK: Methods
    
	private init(identifier: String, apiVersion: String, amount: Decimal, currency: Currency, customer: Customer, isLiveMode: Bool, cardSaved: Bool, object: String, authentication: Authentication?, redirect: TrackingURL, post: TrackingURL?, card: SavedCard?, source: Source, destinations: DestinationGroup?, status: ChargeStatus, requires3DSecure: Bool, transactionDetails: TransactionDetails, descriptionText: String?, metadata: Metadata?, reference: Reference?, receiptSettings: Receipt?, acquirer: Acquirer?, response: Response?, statementDescriptor: String?, authorizeAction: AuthorizeActionResponse) {
        
        self.identifier             = identifier
        self.apiVersion             = apiVersion
        self.amount                 = amount
        self.currency               = currency
        self.customer               = customer
        self.isLiveMode             = isLiveMode
        self.cardSaved              = cardSaved
        self.object                 = object
        self.authentication         = authentication
        self.redirect               = redirect
        self.post                   = post
        self.card                   = card
        self.source                 = source
		self.destinations			= destinations
        self.status                 = status
        self.requires3DSecure       = requires3DSecure
        self.transactionDetails     = transactionDetails
        self.descriptionText        = descriptionText
        self.metadata               = metadata
        self.reference              = reference
        self.receiptSettings        = receiptSettings
        self.acquirer               = acquirer
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
        let apiVersion          = try container.decode          (String.self,                   forKey: .apiVersion)
        let amount              = try container.decode          (Decimal.self,                  forKey: .amount)
        let currency            = try container.decode          (Currency.self,                 forKey: .currency)
        let customer            = try container.decode          (Customer.self,             	forKey: .customer)
        let isLiveMode          = try container.decode          (Bool.self,                     forKey: .isLiveMode)
        let cardSaved           = try container.decodeIfPresent (Bool.self,                     forKey: .cardSaved) ?? false
        let object              = try container.decode          (String.self,                   forKey: .object)
        let authentication      = try container.decodeIfPresent (Authentication.self,           forKey: .authentication)
        let redirect            = try container.decode          (TrackingURL.self,              forKey: .redirect)
        let post                = try container.decodeIfPresent (TrackingURL.self,              forKey: .post)
        let card                = try container.decodeIfPresent	(SavedCard.self,               	forKey: .card)
        let source              = try container.decode          (Source.self,                   forKey: .source)
		let destinations		= try container.decodeIfPresent	(DestinationGroup.self,			forKey: .destinations)
        let status              = try container.decode          (ChargeStatus.self,             forKey: .status)
        let requires3DSecure    = try container.decode          (Bool.self,                     forKey: .requires3DSecure)
        let transactionDetails  = try container.decode          (TransactionDetails.self,       forKey: .transactionDetails)
        let descriptionText     = try container.decodeIfPresent (String.self,                   forKey: .descriptionText)
        let metadata            = try container.decodeIfPresent (Metadata.self,					forKey: .metadata)
        let reference           = try container.decodeIfPresent (Reference.self,                forKey: .reference)
        let receiptSettings     = try container.decodeIfPresent (Receipt.self,                  forKey: .receiptSettings)
        let acquirer            = try container.decodeIfPresent (Acquirer.self,                 forKey: .acquirer)
        let response            = try container.decodeIfPresent (Response.self,                 forKey: .response)
        let statementDescriptor = try container.decodeIfPresent (String.self,                   forKey: .statementDescriptor)
        let authorizeAction     = try container.decode          (AuthorizeActionResponse.self,  forKey: .authorizeAction)
        
        self.init(identifier:           identifier,
                  apiVersion:           apiVersion,
                  amount:               amount,
                  currency:             currency,
                  customer:             customer,
                  isLiveMode:           isLiveMode,
                  cardSaved:            cardSaved,
                  object:               object,
                  authentication:       authentication,
                  redirect:             redirect,
                  post:                 post,
                  card:                 card,
				  source:               source,
				  destinations:			destinations,
                  status:               status,
                  requires3DSecure:     requires3DSecure,
                  transactionDetails:   transactionDetails,
                  descriptionText:      descriptionText,
                  metadata:             metadata,
                  reference:            reference,
                  receiptSettings:      receiptSettings,
                  acquirer:             acquirer,
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
