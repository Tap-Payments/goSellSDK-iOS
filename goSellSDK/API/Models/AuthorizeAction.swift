//
//  AuthorizeAction.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Authorize action model.
@objcMembers public class AuthorizeAction: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Default authorize action (automatically void in 168 hours).
    public static let `default` = AuthorizeAction(type: .void, time: 168)
    
    /// Action type.
    public var type: AuthorizeActionType
    
    /// Time measured in hours.
    public var time: UInt
    
    // MARK: Methods
    
    /// Initializes the model with type and time.
    ///
    /// - Parameters:
    ///   - type: Authorize action type.
    ///   - time: Time in hours. Once reached, based on the `type`, action will be performed.
    public init(type: AuthorizeActionType, time: UInt) {
        
        self.type = type
        self.time = time
        
        super.init()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case time = "time"
    }
}
