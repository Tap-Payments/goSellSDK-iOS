//
//  TapSDKError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Base abstract class for errors.
@objcMembers public class TapSDKError: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Error type.
    public private(set) var type: TapSDKErrorType = .unknown
    
    /// Pretty printed description of TapSDKError object.
    public override var description: String {
        
        return "Error type: \(self.type.description)"
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Designated initializer for the errors.
    ///
    /// - Parameter type: Error type.
    internal init(type: TapSDKErrorType) {
        
        self.type = type
        super.init()
    }
}
