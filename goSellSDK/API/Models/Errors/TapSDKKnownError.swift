//
//  TapSDKKnownError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
        
        let firstLine   = super.description
        let secondLine  = "Underlying error: " + self.errorDescription
        let thirdLine   = "URL response: " + self.urlResponseDescription
        
        let lines: [String] = [firstLine, secondLine, thirdLine]
        
        return lines.joined(separator: "\n")
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
    
    // MARK: - Private -
    // MARK: Properties
    
    private var errorDescription: String {
        
        if let nonnullError = self.error {
            
            return nonnullError.localizedDescription
        }
        else {
            
            return "nil"
        }
    }
    
    private var urlResponseDescription: String {
        
        if let nonnullResponse = self.urlResponse {
            
            return nonnullResponse.description
        }
        else {
            
            return "nil"
        }
    }
}
