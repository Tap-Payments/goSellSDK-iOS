//
//  TapSDKAPIError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// API error.
@objcMembers public final class TapSDKAPIError: TapSDKError {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Underlying API error (parsed error from the backend).
    public private(set) var error: APIError
    
    /// URL response.
    public private(set) var urlResponse: URLResponse?
    
    /// Readable description of the error.
    public override var description: String {
        
        let urlResponseDescription = self.urlResponse?.description ?? "nil"
        return "\(super.description)\nError: \(self.error.description)\nURL response: \(urlResponseDescription)"
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the error with parsed error from the backend and URL response.
    ///
    /// - Parameters:
    ///   - error: Error.
    ///   - response: URL response.
    internal init(error: APIError, response: URLResponse?) {
        
        self.error = error
        self.urlResponse = response
        super.init(type: .api)
    }
}
