//
//  CaptureChargeRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Capture charge request model.
@objcMembers public class CaptureChargeRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The amount to capture, which must be less than or equal to the original amount.
    /// Any additional amount will be automatically refunded.
    public var amount: Decimal
    
    /// The email address to send this charge’s receipt to.
    /// This will override the previously-specified email address for this charge, if one was set.
    /// Receipts will not be sent in test mode.
    public var receiptEmail: String?
    
    /// The mobile number to send this charge’s receipt to.
    /// This will override the previously-specified mobile number for this charge, if one was set.
    /// Receipts will not be sent in test mode.
    public var receiptSMS: String?
    
    /// An arbitrary string to be displayed on your customer's credit card statement.
    /// This may be up to 22 characters.
    /// As an example, if your website is RunClub and the item you're charging for is a race ticket,
    /// you may want to specify a statement_descriptor of RunClub 5K race ticket.
    /// The statement description must contain at least one letter, may not include "' characters,
    /// and will appear on your customer's statement in capital letters.
    /// Non-ASCII characters are automatically stripped.
    /// While most banks and card issuers display this information consistently, some may display it incorrectly or not at all.
    public var statementDescriptor: String?
    
    // MARK: Methods
    
    /// Initializes CaptureChargeRequest model with amount.
    ///
    /// - Parameter amount: Amount.
    public convenience init(amount: Decimal) {
        
        self.init(amount: amount, receiptEmail: nil, receiptSMS: nil, statementDescriptor: nil)
    }
    
    /// Initializes
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - receiptEmail: Receipt email.
    ///   - receiptSMS: Receipt SMS.
    ///   - statementDescriptor: Statement descriptor.
    public init(amount: Decimal, receiptEmail: String?, receiptSMS: String?, statementDescriptor: String?) {
        
        self.amount = amount
        self.receiptEmail = receiptEmail
        self.receiptSMS = receiptSMS
        self.statementDescriptor = statementDescriptor
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount                 = "amount"
        case receiptEmail           = "receipt_email"
        case receiptSMS             = "receipt_sms"
        case statementDescriptor    = "statement_descriptor"
    }
}
