//
//  TapSDKKnownError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Known error. Either network or serialization error.
@objcMembers public final class TapSDKKnownError: TapSDKError {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// URL response (if received) which will help the developer to understand the issue.
    public private(set) var urlResponse: URLResponse?
    
    /// Underlying error.
    public private(set) var error: Error?
    
    /// Readable description of the error.
    public override var description: String {
        
        let errorDescription = self.error == nil ? "nil" : "\(self.error!.localizedDescription)"
        let urlResponseDescription = self.urlResponse?.description ?? "nil"
        return "\(super.description)\nUnderlying error: \(errorDescription)\nURL response: \(urlResponseDescription)"
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the error with type, underlying error and URL response.
    ///
    /// - Parameters:
    ///   - type: Error type.
    ///   - error: Underlying error.
    ///   - response: URL response.
    internal init(type: TapSDKErrorType, error: Error?, response: URLResponse?) {
        
        super.init(type: type)
        self.error = error
        self.urlResponse = response
    }
}

// MARK: - Error
extension TapSDKKnownError: Error {}
