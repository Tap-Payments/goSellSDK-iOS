//
//  PaymentDataSource.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment data source.
@objc public protocol PaymentDataSource: class, NSObjectProtocol {
    
    /// Items currency code. Although the type is nullable, in order to start payment, currency should be nonnull.
    var currency: Currency? { get }
    
    /// Details of the person who pays. Although the type is nullable, in order to start payment, customer should be nonnull.
    var customer: Customer? { get }
    
    /// Payment/Authorization amount.
    /// - Note: Either `amount` or `items` should be implemented. If both are implemented, `items` is preferred and amount is calculated from them.
    ///         If `taxes` and/or `shipping` is implemented, it will affect the value you pass in this property.
    @objc optional var amount: Decimal { get }
    
    /// Items to pay for.
    /// - Note: Either `amount` or `items` should be implemented. If both are implemented, `items` are preferred and amount is calculated from them.
    ///         If `taxes` and/or `shipping` is implemented, it will affect the amount which is calculated based on items you pass in this property.
    @objc optional var items: [PaymentItem]? { get }
    
    /// Transaction mode.
    @objc optional var mode: TransactionMode { get }
    
    /// Taxes.
    @objc optional var taxes: [Tax]? { get }
    
    /// Shipping options.
    @objc optional var shipping: [Shipping]? { get }
    
    /// Post URL. The URL that will be called by Tap system notifying that payment has succeed or failed.
    @objc optional var postURL: URL? { get }
    
    /// Description of the payment.
    @objc optional var paymentDescription: String? { get }
    
    /// Additional information you would like to pass along with the transaction.
    @objc optional var paymentMetadata: [String: String]? { get }
    
    /// Payment reference. Implement this property to keep a reference to the transaction on your backend.
    @objc optional var paymentReference: Reference? { get }
    
    /// Payment statement descriptor.
    @objc optional var paymentStatementDescriptor: String? { get }
    
    /// Defines if 3D secure check is required.
    @objc optional var require3DSecure: Bool { get }
    
    /// Receipt dispatch settings.
    @objc optional var receiptSettings: Receipt? { get }
    
    /// Action to perform after authorization succeeds.
    @objc optional var authorizeAction: AuthorizeAction { get }
}
