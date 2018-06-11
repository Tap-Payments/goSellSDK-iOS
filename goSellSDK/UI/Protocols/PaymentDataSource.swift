//
//  PaymentDataSource.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment data source.
@objc public protocol PaymentDataSource: class, NSObjectProtocol {
    
    /// Items currency code. Although the type is nullable, in order to start payment, currency should be nonnull.
    @objc var currency: Currency? { get }
    
    /// Details of the person who pays. Although the type is nullable, in order to start payment, customer should be nonnull.
    @objc var customer: CustomerInfo? { get }
    
    /// Items to pay for. In order to start payment, array should contain at least one payment item.
    @objc var items: [PaymentItem] { get }
    
    /// Taxes.
    @objc optional var taxes: [Tax]? { get }
    
    /// Shipping options.
    @objc optional var shipping: [Shipping]? { get }
}
