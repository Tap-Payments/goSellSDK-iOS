//
//  ErrorDetail.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Error detail model.
@objcMembers public final class ErrorDetail: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Error name.
    public private(set) var name: String = ""
    
    /// Error message.
    public private(set) var message: String = ""
    
    /// Error description.
    public override var description: String {
        
        return "\(self.name): \(self.message)"
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name       = "fieldname"
        case message    = "message"
    }
}
