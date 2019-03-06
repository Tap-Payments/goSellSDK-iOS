//
//  AuthorizeAction.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Authorize action model.
@objcMembers public class AuthorizeAction: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Default authorize action (automatically void in 168 hours).
    public static let `default` = AuthorizeAction(type: .void, timeInHours: 168)
    
    /// Action type.
    public var type: AuthorizeActionType
    
    /// Time measured in hours.
    public var timeInHours: UInt
    
    // MARK: Methods
    
    /// Initializes the model with type and time.
    ///
    /// - Parameters:
    ///   - type: Authorize action type.
    ///   - timeInHours: Time in hours. Once reached, based on the `type`, action will be performed.
    public init(type: AuthorizeActionType, timeInHours: UInt) {
        
        self.type           = type
        self.timeInHours    = timeInHours
        
        super.init()
    }
    
    /// Creates and returns `AuthorizeAction` instance with capture action after the specified time in hours.
    ///
    /// - Parameter timeInHours: Time in hours.
    /// - Returns: An `AuthorizeAction` instance.
    @objc(captureAfterTimeInHours:) public static func capture(after timeInHours: UInt) -> AuthorizeAction {
        
        return AuthorizeAction(type: .capture, timeInHours: timeInHours)
    }
    
    /// Creatus and returns `AuthorizeAction` instance with void action after the specified time in hours.
    ///
    /// - Parameter timeInHours: Time in hours.
    /// - Returns: an `AuthorizeAction` instance.
    @objc(voidAfterTimeInHours:) public static func void(after timeInHours: UInt) -> AuthorizeAction {
        
        return AuthorizeAction(type: .void, timeInHours: timeInHours)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case type           = "type"
        case timeInHours    = "time"
    }
}
