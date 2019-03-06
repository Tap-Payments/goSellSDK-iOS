//
//  AuthorizeActionStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Status of the automatic scheduled action after successful charge authorization.
@objc public enum AuthorizeActionStatus: Int {
    
    /// Pending.
    case pending
    
    /// Scheduled.
    case scheduled
    
    /// Amount was captured.
    case captured
    
    /// Automatic action failed.
    case failed
    
    /// Declined.
    case declined
    
    /// Amount was void.
    case void
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .pending:      return "PENDING"
        case .scheduled:    return "SCHEDULED"
        case .captured:     return "CAPTURED"
        case .failed:       return "FAILED"
        case .declined:     return "DECLINED"
        case .void:         return "VOID"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case AuthorizeActionStatus.pending.stringValue:     self = .pending
        case AuthorizeActionStatus.scheduled.stringValue:   self = .scheduled
        case AuthorizeActionStatus.captured.stringValue:    self = .captured
        case AuthorizeActionStatus.failed.stringValue:      self = .failed
        case AuthorizeActionStatus.declined.stringValue:    self = .declined
        case AuthorizeActionStatus.void.stringValue:        self = .void
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: AuthorizeActionStatus.self, value: stringValue)
            
        }
    }
}

// MARK: - Decodable
extension AuthorizeActionStatus: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}
