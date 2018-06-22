//
//  APIError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Structure representing API error.
@objcMembers public final class APIError: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Error details.
    public var details: [ErrorDetail] = []
    
    /// Readable description of the error.
    public override var description: String {
        
        if self.details.count == 0 {
            
            return "Backend responded with empty response."
        }
        
        var result = "\nErrors detected on the backend:\n"
        
        for error in self.details {
            
            let whitespacesCount = longestErrorTitleLength - error.name.length
            let extraWhitespaces = String(repeating: " ", count: whitespacesCount)
            result += error.name
            result += ": "
            result += extraWhitespaces
            result += error.message
            result += "\n"
        }
        
        return result
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case details = "errors"
    }
    
    // MARK: Properties
    
    private var longestErrorTitleLength: Int {
        
        let lengths = self.details.map { $0.name.length }
        let result = lengths.max() ?? 0
        
        return result
    }
}
