//
//  goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Base settings class for goSell SDK.
@objcMembers public class goSellSDK: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Secret key.
    public static var secretKey: String = .empty
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}
