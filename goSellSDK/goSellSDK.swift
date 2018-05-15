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
    
    /// Locale identifier. Change this value to see the SDK in different language.
    public static var localeIdentifier: String = Locale.current.identifier
    
    /// Customer. Set this value at any time before user presses Pay button.
    public static var customer: CustomerInfo?
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}
