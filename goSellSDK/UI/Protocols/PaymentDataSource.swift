//
//  PaymentDataSource.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment data source.
@objc public protocol PaymentDataSource: class, NSObjectProtocol {
    
    /// Items currency code.
    @objc var currency: Currency { get }
    
    /// Details of the person who pays.
    @objc var customer: CustomerInfo { get }
    
    /// Items to pay for.
    @objc var items: [PaymentItem] { get }
    
    @objc optional var shipping: [Shipping]? { get }
}
