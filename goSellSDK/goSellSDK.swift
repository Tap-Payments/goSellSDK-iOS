//
//  goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Base settings class for goSell SDK.
@objcMembers public final class goSellSDK: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// SDK mode. By default, `production`.
    ///
    /// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
    public static var mode: SDKMode = .production
    
    /// Secret key.
    ///
    /// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
    public static var secretKey: SecretKey = .empty
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}
