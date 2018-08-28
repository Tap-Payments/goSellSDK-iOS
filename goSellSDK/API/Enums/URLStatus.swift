//
//  URLStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// URL Status.
@objc public enum URLStatus: Int {
    
    /// URL was not called.
    case pending
    
    /// URL call succeed.
    case success
    
    /// URL call failed.
    case failed
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .pending:  return "PENDING"
        case .success:  return "SUCCESS"
        case .failed:   return "FAILED"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case URLStatus.pending.stringValue: self = .pending
        case URLStatus.success.stringValue: self = .success
        case URLStatus.failed.stringValue:  self = .failed
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: URLStatus.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension URLStatus: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let stringValue = try container.decode(String.self)
        try self.init(stringValue)
    }
}

// MARK: - Encodable
extension URLStatus: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
