//
//  APIError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Structure representing API error.
@objcMembers public class APIError: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Error details.
    public var details: [ErrorDetail] = []
    
    /// Readable description of the error.
    public override var description: String {
        
        guard self.details.count > 0 else {
            
            return "Backend responded with empty response."
        }
        
        var result = "\nErrors detected on the backend:\n"
        let longestErrorTitleLength = (self.details.map { $0.name.count }).max()!
        
        for error in self.details {
            
            let extraWhitespaces = String(repeating: " ", count: longestErrorTitleLength - error.name.count)
            result += error.name + ": " + extraWhitespaces + error.message + "\n"
        }
        
        return result
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case details = "errors"
    }
}
