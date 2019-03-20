//
//  APIError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Structure representing API error.
@objcMembers public final class APIError: NSObject, Codable {
    
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
            
            let whitespacesCount = longestErrorTitleLength - error.title.tap_length
            let extraWhitespaces = String(repeating: " ", count: whitespacesCount)
            result += error.title
            result += ": "
            result += extraWhitespaces
            result += error.descriptionText
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
        
        let lengths = self.details.map { $0.title.tap_length }
        let result = lengths.max() ?? 0
        
        return result
    }
}
