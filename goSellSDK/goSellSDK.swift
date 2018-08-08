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
    
    /// Secret key.
    public static var secretKey: String = .empty
    
    /// Customer. Set this value at any time before user presses Pay button.
    public static var customer: CustomerInfo?
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Locale identifier. Change this value to see the SDK in different language.
    internal static let localeIdentifier: String = "en"
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}
