//
//  Charge.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDate.Date
import struct Foundation.NSDecimal.Decimal
import class Foundation.NSObject.NSObject
import struct Foundation.NSURL.URL

// MARK: - Charge -

/// Charge model.
/// To charge a credit or a debit card, you create a charge object.
/// You can retrieve and refund individual charges as well as list all charges.
/// Charges are identified by a unique random ID.
@objcMembers public final class Charge: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value. (value is "charge")
    public private(set) var object: String?
    
    /// Flag indicating whether the object exists in live mode or test mode.
    public private(set) var isLiveMode: Bool = false
    
    /// Charge status.
    public private(set) var status: ChargeStatus = .failed
    
    /// Terminal ID (Virtual terminal ID or Physical Terminal ID (POS))
    public private(set) var terminalID: String?
    
    /// Transaction Authorization ID issued by Gateway
    public private(set) var authID: String?
    
    /// Tap response.
    public private(set) var response: MessagedResponse?
    
    /// Acquirer response.
    public private(set) var acquirerResponse: MessagedResponse?
    
    /// Defines if 3DS is required.
    public private(set) var requires3DSecure: Bool = false
    
    /// Merchant transaction reference number.
    public private(set) var transactionReference: String?
    
    /// Merchant order reference number.
    public private(set) var orderReference: String?
    
    /// Timezone of the charge.
    public private(set) var timezone: String?
    
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public private(set) var creationDate: Date?
    
    /// Time at which the object was posted into the business statememnt. Measured in seconds since the Unix epoch.
    public private(set) var postDate: Date?
    
    /// A positive integer in the smallest currency unit representing how much to charge.
    public private(set) var amount: Decimal = 0.0
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public private(set) var currency: String?

    /// Extra information about a charge.
    /// This will appear on your customer’s credit card statement.
    /// It must contain at least one letter.
    public private(set) var statementDescriptor: String?
    
    /// Whether chargeback applied or not.
    public private(set) var chargeback: Bool = false
    
    /// Whether Receipt email and sms need to be sent or not, default will be true (if customer emil and phone info available, then receipt will be sent)
    public private(set) var receipt: ChargeReceipt?
    
    /// ID of the customer this charge is for if one exists.
    public private(set) var customer: ChargeCustomer?
    
    /// The source of every charge is a credit or debit card. This hash is then the card object describing that card.
    /// If source is null then, default Tap payment page link will be provided.
    /// if source.id = "src_kw.knet" then KNET payment page link will be provided.
    /// if source.id = "src_visamastercard" then Credit Card payment page link will be provided.
    public private(set) var source: ChargeSource?
    
    /// Information related to the payment page redirect.
    public private(set) var redirect: ChargeRedirect?
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public private(set) var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public private(set) var metadata: [String: String]?
    
    /// Pretty printed description of the Charge object.
    public override var description: String {
        
        let lines: [String] = [
        
            "Charge",
            "identifier:                \(self.identifier?.description ?? "nil")",
            "object:                    \(self.object?.description ?? "nil")",
            "live mode:                 \(self.isLiveMode)",
            "status:                    \(self.status.stringValue)",
            "terminal ID:               \(self.terminalID ?? "nil")",
            "auth ID:                   \(self.authID ?? "nil")",
            "requires 3D secure:        \(self.requires3DSecure)",
            "transaction reference:     \(self.transactionReference ?? "nil")",
            "order reference:           \(self.orderReference ?? "nil")",
            "time zone:                 \(self.timezone ?? "nil")",
            "creation date:             \(self.creationDate?.description ?? "nil")",
            "post time:                 \(self.postDate?.description ?? "nil")",
            "amount:                    \(self.amount)",
            "currency:                  \(self.currency?.description ?? "nil")",
            "statement descriptor:      \(self.statementDescriptor ?? "nil")",
            "chargeback:                \(self.chargeback)",
            "description:               \(self.descriptionText?.description ?? "nil")",
            "metadata:                  \(self.metadata?.description ?? "nil")",
            "response:                  \(self.response?.description(with: 31) ?? "nil")",
            "acquirer response:         \(self.acquirerResponse?.description(with: 31) ?? "nil")",
            "receipt:                   \(self.receipt?.description(with: 31) ?? "nil")",
            "customer:                  \(self.customer?.description(with: 31) ?? "nil")",
            "source:                    \(self.source?.description(with: 31) ?? "nil")",
            "redirect:                  \(self.redirect?.description(with: 31) ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case object                 = "object"
        case isLiveMode             = "live_mode"
        case status                 = "status"
        case terminalID             = "terminal_id"
        case authID                 = "auth_id"
        case requires3DSecure       = "threeDSecure"
        case transactionReference   = "transaction_reference"
        case orderReference         = "order_reference"
        case timezone               = "timezone"
        case creationDate           = "created"
        case postDate               = "post"
        case amount                 = "amount"
        case currency               = "currency"
        case statementDescriptor    = "statement_descriptor"
        case chargeback             = "chargeback"
        case response               = "response"
        case acquirerResponse       = "acquirer"
        case receipt                = "receipt"
        case customer               = "customer"
        case source                 = "source"
        case redirect               = "redirect"
        case descriptionText        = "description"
        case metadata               = "metadata"
    }
}

// MARK: - MessagedResponse -

/// A model that contains response code and a message.
@objcMembers public final class MessagedResponse: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Response code.
    public private(set) var code: String = ""
    
    /// Response message.
    public private(set) var message: String = ""
    
    /// Pretty printed object description.
    public override var description: String {
        
        let lines: [String] = [
        
            "Messaged Response",
            "code:             \(self.code)",
            "message:          \(self.message)"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case code       = "code"
        case message    = "message"
    }
}

// MARK: - ChargeReceipt -

/// Charge receipt settings model.
@objcMembers public final class ChargeReceipt: CreateChargeReceipt, Identifiable, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    public let identifier: String?
    
    /// Pretty printed object description.
    public override var description: String {
        
        let lines: [String] = [
        
            "Receipt",
            "identifier: \(self.identifier ?? "nil")",
            "email:      \(self.email)",
            "sms:        \(self.sms)"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: Methods
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String?.self, forKey: .identifier)
        let sms = try container.decode(Bool.self, forKey: .sms)
        let email = try container.decode(Bool.self, forKey: .email)
        
        self.init(id: id, email: email, sms: sms)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case email      = "email"
        case sms        = "sms"
        case identifier = "id"
    }
    
    // MARK: Methods
    
    private init(id: String?, email: Bool, sms: Bool) {
        
        self.identifier = id
        super.init(email: email, sms: sms)
    }
}

// MARK: - ChargeCustomer -

/// Customer charge model.
@objcMembers public final class ChargeCustomer: CreateChargeCustomer, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Object type.
    public private(set) var object: String?
    
    /// Pretty printed object description.
    public override var description: String {
        
        let lines: [String] = [
        
            "Customer",
            "identifier: \(self.identifier ?? "nil")",
            "object:     \(self.object ?? "nil")",
            "first name: \(self.firstName ?? "nil")",
            "last name:  \(self.lastName ?? "nil")",
            "email:      \(self.email ?? "nil")",
            "phone:      \(self.phone ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: Methods
    
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        let identifier  = container.contains(.identifier)   ? try container.decode(String?.self, forKey: .identifier)   : nil
        let object      = container.contains(.object)       ? try container.decode(String?.self, forKey: .object)       : nil
        let firstName   = container.contains(.firstName)    ? try container.decode(String?.self, forKey: .firstName)    : nil
        let lastName    = container.contains(.lastName)     ? try container.decode(String?.self, forKey: .lastName)     : nil
        let email       = container.contains(.email)        ? try container.decode(String?.self, forKey: .email)        : nil
        let phone       = container.contains(.phone)        ? try container.decode(String?.self, forKey: .phone)        : nil
        
        self.object = object
        super.init(identifier: identifier, firstName: firstName, lastName: lastName, email: email, phone: phone)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case email      = "email"
        case phone      = "phone"
        case object     = "object"
    }
}

// MARK: - ChargeStatus -

/// Charge status enum.
///
/// - initiated: Charge is initiated.
/// - inProgress: Charge is in progress and is waiting for user action (3d secure, OTP etc.)
/// - cancelled: Charge cancelled.
/// - failed: Charge failed.
/// - declined: Charge declined.
/// - restricted: Charge restricted.
/// - captured: Charge captured.
/// - void: Charge voided.
@objc public enum ChargeStatus: Int, Decodable {
    
    /// Charge is initiated.
    case initiated
    
    /// Charge is in progress and is waiting for user action (3d secure, OTP etc.)
    case inProgress
    
    /// Charge cancelled.
    case cancelled
    
    /// Charge failed.
    case failed
    
    /// Charge declined.
    case declined
    
    /// Charge restricted.
    case restricted
    
    /// Charge captured.
    case captured
    
    /// Charge voided.
    case void
    
    // MARK: - Public -
    // MARK: Methods
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        switch stringValue {
            
        case StringValues.initiated     : self = .initiated
        case StringValues.inProgress    : self = .inProgress
        case StringValues.cancelled     : self = .cancelled
        case StringValues.failed        : self = .failed
        case StringValues.declined      : self = .declined
        case StringValues.restricted    : self = .restricted
        case StringValues.captured      : self = .captured
        case StringValues.void          : self = .void
            
        default                         : self = .failed

        }
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var stringValue: String {
        
        switch self {
            
        case .initiated : return StringValues.initiated
        case .inProgress: return StringValues.inProgress
        case .cancelled : return StringValues.cancelled
        case .failed    : return StringValues.failed
        case .declined  : return StringValues.declined
        case .restricted: return StringValues.restricted
        case .captured  : return StringValues.captured
        case .void      : return StringValues.void
            
        }
    }
    
    // MARK: - Private -
    
    private struct StringValues {
        
        fileprivate static let initiated    = "INITIATED"
        fileprivate static let inProgress   = "IN_PROGRESS"
        fileprivate static let cancelled    = "CANCELLED"
        fileprivate static let failed       = "FAILED"
        fileprivate static let declined     = "DECLINED"
        fileprivate static let restricted   = "RESTRICTED"
        fileprivate static let captured     = "CAPTURED"
        fileprivate static let void         = "VOID"
        
        @available(*, unavailable) private init() {}
    }
}

// MARK: - ChargeRedirect -

/// Redirect model.
@objcMembers public final class ChargeRedirect: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    public private(set) var status: String?
    
    /// This is the payment URL that will be passed to you to forward it to your customer.
    /// This url, will contain a checkout page with all the details provided in the request's body.
    public private(set) var url: URL?
    
    /// The URL you provide to redirect the customer to after they completed their payment.
    /// The status of the payment is either succeeded, pending, or failed.
    /// Also "payload" (charge response) will be posted to the return_url
    public private(set) var returnURL: URL?
    
    /// The URL you provide to post the charge response after completion of payment.
    /// The status of the payment is either succeeded, pending, or failed
    public private(set) var postURL: URL?
    
    /// Pretty printed description of the ChargeRedirect object.
    public override var description: String {
        
        let lines: [String] = [
        
            "Redirect",
            "status:     \(self.status?.description ?? "nil")",
            "url:        \(self.url?.description ?? "nil")",
            "return url: \(self.returnURL?.description ?? "nil")",
            "post url:   \(self.postURL?.description ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status     = "status"
        case url        = "url"
        case returnURL  = "return_url"
        case postURL    = "post_url"
    }
}

// MARK: - PaymentType -

/// Payment type enum.
///
/// - debitCard: DEBIT card.
/// - creditCard: CREDIT card.
/// - prepaidCard: PREPAID card.
/// - prepaidWallet: Prepaid wallet.
@objc public enum PaymentType: Int, Decodable {
    
    /// DEBIT card.
    case debitCard
    
    /// CREDIT card.
    case creditCard
    
    /// PREPAID card.
    case prepaidCard
    
    /// Prepaid wallet.
    case prepaidWallet
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Initializes payment type value from its string representation.
    ///
    /// - Parameter stringValue: String representation of `PaymentType` enum.
    public init(stringValue: String) {
        
        switch stringValue {
            
        case StringValues.debitCard     : self = .debitCard
        case StringValues.creditCard    : self = .creditCard
        case StringValues.prepaidCard   : self = .prepaidCard
        case StringValues.prepaidWallet : self = .prepaidWallet
            
        default                         : self = .creditCard

        }
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        self.init(stringValue: stringValue)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var stringValue: String {
        
        switch self {
            
        case .creditCard    : return StringValues.creditCard
        case .debitCard     : return StringValues.debitCard
        case .prepaidCard   : return StringValues.prepaidWallet
        case .prepaidWallet : return StringValues.prepaidWallet

        }
    }
    
    // MARK: - Private -
    
    private struct StringValues {
        
        fileprivate static let debitCard        = "DEBIT_CARD"
        fileprivate static let creditCard       = "CREDIT_CARD"
        fileprivate static let prepaidCard      = "PREPAID_CARD"
        fileprivate static let prepaidWallet    = "PREPAID_WALLET"
        
        @available(*, unavailable) private init() {}
    }
}

// MARK: - ChargeSource -

/// Source model.
@objcMembers public final class ChargeSource: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value.
    public private(set) var object: String?
    
    /// The last 4 digits of the card.
    public private(set) var lastFourDigits: String?
    
    /// Card type.
    public private(set) var paymentType: PaymentType = .creditCard
    
    /// Pretty printed description of the ChargeSource object.
    public override var description: String {
        
        let lines: [String] = [
        
            "Source",
            "identifier:       \(self.identifier?.description ?? "nil")",
            "object:           \(self.object?.description ?? "nil")",
            "last 4 digits:    \(self.lastFourDigits?.description ?? "nil")",
            "payment type:     \(self.paymentType.stringValue)"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "card_last4"
        case paymentType        = "payment_type"
    }
}
