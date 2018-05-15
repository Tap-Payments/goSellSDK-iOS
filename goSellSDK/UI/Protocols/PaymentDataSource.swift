//
//  PaymentDataSource.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment data source.
@objc public protocol PaymentDataSource: class, NSObjectProtocol {
    
    /// Details of the person who pays.
    var customer: CustomerInfo { get }
    
    /// Items to pay for.
    var items: [PaymentItem] { get }
    
    /// Items currency code.
    var currency: Currency { get }
}
