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
@objcMembers public class CreateChargeRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Amount.
    public var amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public var currency: String
    
    /// Information related to the redirect.
    public var redirect: CreateChargeRedirect
    
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_card" then Credit Card payment page link will be provided.
    /// if source.id = "Card Token ID or Card ID" then Credit Card payment processing page link will be provided.
    public var source: CreateChargeSource?
    
    /// An arbitrary string to be displayed on your customer's credit card statement.
    /// This may be up to 22 characters.
    /// As an example, if your website is RunClub and the item you're charging for is a race ticket, you may want to specify a statement_descriptor of RunClub 5K race ticket.
    /// The statement description must contain at least one letter, may not include <>"' characters, and will appear on your customer's statement in capital letters.
    /// Non-ASCII characters are automatically stripped.
    /// While most banks and card issuers display this information consistently, some may display it incorrectly or not at all.
    public var statementDescriptor: String?
    
    /// An arbitrary string which you can attach to a Charge object. It is displayed when in the web interface alongside the charge.
    public var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    /// Individual keys can be unset by posting an empty value to them.
    /// All keys can be unset by posting an empty value to metadata.
    public var metadata: [String: String]?
    
    /// The mobile number to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the mobile number specified here will override the customer's mobile number.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_sms is specified for a charge in live mode, a receipt will be sent regardless of your sms settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    public var receiptSMS: String?
    
    /// The email address to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the email address specified here will override the customer's email address.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_email is specified for a charge in live mode, a receipt will be sent regardless of your email settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    public var receiptEmail: String?
    
    // MARK: Methods
    
    /// Initializes charge request without providing the source object.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - redirect: Redirect object.
    public convenience init(amount: Decimal, currency: String, redirect: CreateChargeRedirect) {
        
        self.init(amount: amount,
                  currency: currency,
                  redirect: redirect,
                  source: nil)
    }
    
    /// Initializes charge request with a source object.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency.
    ///   - redirect: Redirect object.
    ///   - source: Source object.
    public convenience init(amount: Decimal, currency: String, redirect: CreateChargeRedirect, source: CreateChargeSource?) {
        
        self.init(amount: amount,
                  currency: currency,
                  redirect: redirect,
                  source: source,
                  statementDescriptor: nil,
                  descriptionText: nil,
                  metadata: nil,
                  receiptSMS: nil,
                  receiptEmail: nil)
    }
    
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
    public init(amount: Decimal, currency: String, redirect: CreateChargeRedirect, source: CreateChargeSource? = nil, statementDescriptor: String? = nil, descriptionText: String? = nil, metadata: [String: String]? = nil, receiptSMS: String?, receiptEmail: String?) {
        
        self.amount = amount
        self.currency = currency
        self.source = source
        self.statementDescriptor = statementDescriptor
        self.redirect = redirect
        self.descriptionText = descriptionText
        self.metadata = metadata
        self.receiptSMS = receiptSMS
        self.receiptEmail = receiptEmail
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount
        case currency
        case source
        case statementDescriptor = "statement_descriptor"
        case redirect
        case descriptionText = "description"
        case metadata
        case receiptSMS = "receipt_sms"
        case receiptEmail = "receipt_email"
    }
}

// MARK: - CreateChargeRedirect -

/// Redirect model.
@objcMembers public class CreateChargeRedirect: NSObject, Encodable {
    
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
        
        case returnURL = "return_url"
        case postURL = "post_url"
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
@objcMembers public class CreateChargeSource: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Initializes the source with token identifier.
    ///
    /// - Parameter tokenIdentifier: Token identifier.
    public convenience init(tokenIdentifier: String) {
        
        self.init(identifier: tokenIdentifier)
    }
    
    /// Initializes the source with static identifier.
    ///
    /// - Parameter staticIdentifier: Static identifier.
    public convenience init(staticIdentifier: SourceIdentifier) {
        
        self.init(identifier: staticIdentifier.stringValue)
    }
    
    /// Initializes the source with card number, expiration month, expiration year and CVC code.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - expirationMonth: Expiration month.
    ///   - expirationYear: Expiration year.
    ///   - cvc: CVC code.
    public convenience init(cardNumber: String, expirationMonth: Int, expirationYear: Int, cvc: String) {
        
        self.init(cardNumber: cardNumber,
                  expirationMonth: expirationMonth,
                  expirationYear: expirationYear,
                  cvc: cvc,
                  cardholderName: nil,
                  addressCity: nil,
                  addressCountry: nil,
                  addressState: nil,
                  addressLine1: nil,
                  addressLine2: nil,
                  addressZip: 0)
    }
    
    /// Initializes the source with full card data.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - expirationMonth: Expiration month.
    ///   - expirationYear: Expiration year.
    ///   - cvc: CVC code.
    ///   - cardholderName: Cardholder name.
    ///   - addressCity: Address city.
    ///   - addressCountry: Address country.
    ///   - addressState: Address state.
    ///   - addressLine1: Address line 1.
    ///   - addressLine2: Address line 2.
    ///   - addressZip: Address zip code.
    public init(cardNumber: String, expirationMonth: Int, expirationYear: Int, cvc: String, cardholderName: String?, addressCity: String?, addressCountry: String?, addressState: String?, addressLine1: String?, addressLine2: String?, addressZip: Int) {
        
        self.object = "card"
        
        self.number = cardNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvc = cvc
        self.cardholderName = cardholderName
        self.addressCity = addressCity
        self.addressCountry = addressCountry
        self.addressState = addressState
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        
        if addressZip > 0 {
            
            self.addressZip = addressZip
        }
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case object
        case number
        case expirationMonth = "exp_month"
        case expirationYear = "exp_year"
        case cvc
        case cardholderName = "name"
        case addressCity = "address_city"
        case addressCountry = "address_country"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case addressState = "address_state"
        case addressZip = "address_zip"
    }
    
    // MARK: Properties
    
    /// A payment source to be charged, such as a credit card.
    /// If you also pass a customer ID, the source must be the ID of a source belonging to the customer (e.g., a saved card).
    /// Otherwise, if you do not pass a customer ID, the source you provide must can be a token or card id or source id.
    /// Default source id's (KNET - src_kw.knet, Visa/MasterCard - src_visamastercard)
    private var identifier: String?
    
    /// The type of payment source.
    private var object: String?
    
    /// Card number, as a string without any separators.
    private var number: String?
    
    /// Two digit number representing the card's expiration month.
    private var expirationMonth: Int?
    
    /// Two or four digit number representing the card's expiration year.
    private var expirationYear: Int?
    
    /// Card security code.
    private var cvc: String?
    
    /// Cardholder name.
    private var cardholderName: String?
    
    /// City/District/Suburb/Town/Village.
    private var addressCity: String?
    
    /// Billing address country, if provided when creating card.
    private var addressCountry: String?
    
    /// Address line 1 (Street address/PO Box/Company name).
    private var addressLine1: String?
    
    /// Address line 2 (Apartment/Suite/Unit/Building).
    private var addressLine2: String?
    
    /// State/County/Province/Region.
    private var addressState: String?
    
    /// Zip or postal code.
    private var addressZip: Int?
    
    // MARK: Methods
    
    private init(identifier: String) {
        
        self.identifier = identifier
        
        super.init()
    }
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated without parameters.")
    }
}
