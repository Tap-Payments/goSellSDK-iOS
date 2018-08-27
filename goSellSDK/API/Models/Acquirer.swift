//
//  Acquirer.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objcMembers public final class Acquirer: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Acquirer response.
    public private(set) var response: Response?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case response = "response"
    }
}
