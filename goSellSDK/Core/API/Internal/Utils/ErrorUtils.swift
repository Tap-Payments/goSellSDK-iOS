//
//  ErrorUtils.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal class ErrorUtils {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func createEnumStringInitializationError<T>(for enumerationType: T.Type, value: String) -> TapSDKError {
        
        let userInfo: [String: String] = [
            
            ErrorConstants.UserInfoKeys.enumName: String(describing: enumerationType),
            ErrorConstants.UserInfoKeys.enumValue: value
        ]
        
        let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidEnumValue.rawValue, userInfo: userInfo)
		return TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    //@available(*, unavailable) private init() { }
}
