//
//  CreateCardRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Create card request model.
@objcMembers public class CreateCardRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Credit card details, with the options.
    public var source: String
    
    // MARK: Methods
    
    /// Initializes CreditCardRequest with the source object.
    ///
    /// - Parameter tokenIdentifier: Token identifier.
    public init(tokenIdentifier: String) {
        
        self.source = tokenIdentifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case source = "source"
    }
}
