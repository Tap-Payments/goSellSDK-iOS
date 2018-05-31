//
//  CreateChargeRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDecimal.Decimal
import class Foundation.NSObject.NSObject
import struct Foundation.NSURL.URL

// MARK: - CreateChargeRequest -

/// Create charge request model.
@objcMembers public final class CreateChargeRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// A positive decimal amount representing how much to charge.
    public var amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public var currency: String
    
    /// Whether 3DSecure applied for this transaction or not (can be dicided by business,
    /// however final decision will be taken by Tap)
    public var require3DSecure: Bool
    
    /// Merchant transaction reference number.
    public var transactionReference: String?
    
    /// Merchant order reference number.
    public var orderReference: String?
    
    /// An arbitrary string to be displayed on your customer's credit card statement.
    /// This may be up to 22 characters.
    /// As an example, if your website is RunClub and the item you're charging for is a race ticket, you may want to specify a statement_descriptor of RunClub 5K race ticket.
    /// The statement description must contain at least one letter, may not include <>"' characters, and will appear on your customer's statement in capital letters.
    /// Non-ASCII characters are automatically stripped.
    /// While most banks and card issuers display this information consistently, some may display it incorrectly or not at all.
    public var statementDescriptor: String?
    
    /// Whether Receipt email and sms need to be sent or not, default will be true (if customer email and phone info available, then receipt will be sent)
    public var receipt: CreateChargeReceipt?
    
    /// Customer model.
    public var customer: CreateChargeCustomer
    
    /// A payment source to be charged, such as a credit card.
    /// If you also pass a customer ID, the source must be the ID of a source belonging to the customer (e.g., a saved card).
    /// Otherwise, if you do not pass a customer ID, the source you provide must either be a token or a dictionary containing a user's credit card details,
    /// with the options described below. Although not all information is required, the extra info helps prevent fraud.
    public var source: CreateChargeSource?
    
    /// Information related to the redirect.
    public var redirect: CreateChargeRedirect
    
    /// An arbitrary string which you can attach to a Charge object.
    /// It is displayed when in the web interface alongside the charge.
    public var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    /// Individual keys can be unset by posting an empty value to them.
    /// All keys can be unset by posting an empty value to metadata.
    public var metadata: [String: String]?
    
    // MARK: Methods
    
    /// Initializes charge request without providing the source object.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - customer: Customer object.
    ///   - redirect: Redirect object.
    public convenience init(amount: Decimal, currency: String, customer: CreateChargeCustomer, redirect: CreateChargeRedirect) {
        
        self.init(amount: amount, currency: currency, customer: customer, redirect: redirect, source: nil)
    }
    
    /// Initializes charge request with a source object.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - customer: Customer object.
    ///   - redirect: Redirect object.
    ///   - source: Source object.
    public convenience init(amount: Decimal, currency: String, customer: CreateChargeCustomer, redirect: CreateChargeRedirect, source: CreateChargeSource?) {
        
        self.init(amount: amount, currency: currency, customer: customer, redirect: redirect, source: source, transactionReference: nil, orderReference: nil)
    }
    
    /// Initializes charge request with a source object.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - customer: Customer object.
    ///   - redirect: Redirect object.
    ///   - source: Source object.
    ///   - transactionReference: Merchant transaction reference number.
    ///   - orderReference: Merchant order reference number.
    public convenience init(amount: Decimal, currency: String, customer: CreateChargeCustomer, redirect: CreateChargeRedirect, source: CreateChargeSource?, transactionReference: String?, orderReference: String?) {
        
        self.init(amount: amount,
                  currency: currency,
                  customer: customer,
                  redirect: redirect,
                  source: source,
                  transactionReference: transactionReference,
                  orderReference: orderReference,
                  statementDescriptor: nil,
                  receipt: nil,
                  descriptionText: nil,
                  metadata: nil)
    }
    
    /// Initializes charge request with all possible fields.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - customer: Customer identifier.
    ///   - redirect: Redirect object.
    ///   - source: Source object.
    ///   - transactionReference: Merchant transaction reference number.
    ///   - orderReference: Merchant order reference number.
    ///   - statementDescriptor: Statement descriptor.
    ///   - require3DSecure: Defines if 3DS is required.
    ///   - receipt: Controls receipt dispatch settings.
    ///   - descriptionText: Description.
    ///   - metadata: Metadata.
    public init(amount: Decimal,
                currency: String,
                customer: CreateChargeCustomer,
                redirect: CreateChargeRedirect,
                source: CreateChargeSource? = nil,
                transactionReference: String? = nil,
                orderReference: String? = nil,
                statementDescriptor: String? = nil,
                require3DSecure: Bool = false,
                receipt: CreateChargeReceipt? = nil,
                descriptionText: String? = nil,
                metadata: [String: String]? = nil) {
        
        self.amount                 = amount
        self.currency               = currency
        self.customer               = customer
        self.redirect               = redirect
        self.source                 = source
        self.transactionReference   = transactionReference
        self.orderReference         = orderReference
        self.statementDescriptor    = statementDescriptor
        self.require3DSecure        = require3DSecure
        self.receipt                = receipt
        self.descriptionText        = descriptionText
        self.metadata               = metadata
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount                 = "amount"
        case currency               = "currency"
        case require3DSecure        = "threeDSecure"
        case transactionReference   = "transaction_reference"
        case orderReference         = "order_reference"
        case statementDescriptor    = "statement_descriptor"
        case receipt                = "receipt"
        case customer               = "customer"
        case source                 = "source"
        case redirect               = "redirect"
        case descriptionText        = "description"
        case metadata               = "metadata"
        
    }
}

// MARK: - CreateChargeReceipt -

/// Controls receipt dispatch.
@objcMembers public class CreateChargeReceipt: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Defines if receipt email should be sent.
    public var email: Bool
    
    /// Defines if receipt sms should be sent.
    public var sms: Bool
    
    // MARK: Methods
    
    /// Initializes `CreateChargeReceipt` with 2 booleans defining whether to send or not email & sms.
    ///
    /// - Parameters:
    ///   - email: Defines if receipt email should be sent.
    ///   - sms: Defines if receipt sms should be sent.
    public init(email: Bool, sms: Bool) {
        
        self.email = email
        self.sms = sms
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case email  = "email"
        case sms    = "sms"
    }
}

// MARK: - CreateChargeCustomer -

/// Customer model to pass inside CreateChargeRequest.
@objcMembers public class CreateChargeCustomer: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Customer identifier.
    public var identifier: String?
    
    /// /// Customer's first name. If customer identifier is provided, then it is not required.
    public var firstName: String?
    
    /// Customer's last name. If customer identifier is provided, then it is not required.
    public var lastName: String?
    
    /// The email address to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the email address specified here will override the customer's email address.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_email is specified for a charge in live mode, a receipt will be sent regardless of your email settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    public var email: String?
    
    /// The mobile number to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the mobile number specified here will override the customer's mobile number.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_sms is specified for a charge in live mode, a receipt will be sent regardless of your sms settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    public var phone: String?
    
    // MARK: Methods
    
    /// Inititalizes the customer with customer identifier.
    ///
    /// - Parameter identifier: Customer identifier.
    public convenience init(identifier: String) {
        
        self.init(identifier: identifier, firstName: nil, lastName: nil, email: nil, phone: nil)
    }
    
    /// Initializes the customer with first name, last name, email address and phone number.
    ///
    /// - Parameters:
    ///   - firstName: First name.
    ///   - lastName: Last name.
    ///   - email: Email address.
    ///   - phone: Phone number.
    public convenience init(firstName: String, lastName: String?, email: String, phone: String) {
        
        self.init(identifier: nil, firstName: firstName, lastName: lastName, email: email, phone: phone)
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(identifier: String?, firstName: String?, lastName: String?, email: String?, phone: String?) {
        
        super.init()
        
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case email      = "email"
        case phone      = "phone"
    }
    
    // MARK: Methods
    
     private override init() { super.init() }
}

// MARK: - CreateChargeRedirect -

/// Redirect model.
@objcMembers public final class CreateChargeRedirect: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The URL you provide to redirect the customer to after they completed their payment.
    /// The status of the payment is either succeeded, pending, or failed.
    /// Also "payload" (charge response) will be posted to the return_url
    public var returnURL: URL
    
    /// The URL you provide to post the charge response after completion of payment.
    /// The status of the payment is either succeeded, pending, or failed
    public var postURL: URL?
    
    // MARK: Methods
    
    /// Initializes redirect model with the return URL.
    ///
    /// - Parameter returnURL: Return URL.
    public convenience init(returnURL: URL) {
        
        self.init(returnURL: returnURL, postURL: nil)
    }
    
    /// Initializes the redirect model with return URL and post URL
    ///
    /// - Parameters:
    ///   - returnURL: Return URL
    ///   - postURL: Post URL
    public init(returnURL: URL, postURL: URL? = nil) {
        
        self.returnURL = returnURL
        self.postURL = postURL
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case returnURL  = "return_url"
        case postURL    = "post_url"
    }
}

// MARK: - SourceIdentifier -

/// Static source identifier.
///
/// - KNET: KNET source identifier.
/// - BENEFIT: Benefit source identifier.
/// - SADAD: Sadad source identifier.
/// - FAWRY: Fawry source identifier.
@objc public enum SourceIdentifier: Int {
    
    /// KNET source identifier.
    case KNET
    
    /// Benefit source identifier.
    case BENEFIT
    
    /// Sadad source identifier.
    case SADAD
    
    /// Fawry source identifier.
    case FAWRY
    
    fileprivate var stringValue: String {

        switch self {

        case .KNET:

            return Constants.knetIdentifier

        case .BENEFIT:

            return Constants.benefitIdentifier

        case .SADAD:

            return Constants.sadadIdentifier

        case .FAWRY:

            return Constants.fawryIdentifier
        }
    }

    private struct Constants {

        fileprivate static let knetIdentifier = "src_kw.knet"
        fileprivate static let benefitIdentifier = "src_bh.benefit"
        fileprivate static let sadadIdentifier = "src_sa.sadad"
        fileprivate static let fawryIdentifier = "src_eg.fawry"

        @available(*, unavailable) private init() {

            fatalError("This type cannot be instantiated.")
        }
    }
}

// MARK: - CreateChargeSource -

/// Source request model.
@objcMembers public final class CreateChargeSource: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Initializes the source with token identifier.
    ///
    /// - Parameter tokenIdentifier: Token identifier.
    public convenience init(tokenIdentifier: String) {
        
        self.init(identifier: tokenIdentifier)
    }
    
    /// Initializes the source with card identifier.
    ///
    /// - Parameter cardIdentifier: Card identifier.
    public convenience init(cardIdentifier: String) {
        
        self.init(identifier: cardIdentifier)
    }
    
    /// Initializes the source with static identifier.
    ///
    /// - Parameter staticIdentifier: Static identifier.
    public convenience init(staticIdentifier: SourceIdentifier) {
        
        self.init(identifier: staticIdentifier.stringValue)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
    }
    
    // MARK: Properties
    
    /// A payment source to be charged, such as a credit card.
    /// If you also pass a customer ID, the source must be the ID of a source belonging to the customer (e.g., a saved card).
    /// Otherwise, if you do not pass a customer ID, the source you provide must can be a token or card id or source id.
    /// Default source id's (KNET - src_kw.knet, Visa/MasterCard - src_visamastercard)
    private var identifier: String?
    
    // MARK: Methods
    
    private init(identifier: String) {
        
        self.identifier = identifier
        
        super.init()
    }
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated without parameters.")
    }
}
