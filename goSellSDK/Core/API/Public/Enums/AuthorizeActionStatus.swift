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
    
    case authorized
    
    case initiated
    
    case inProgress
    
    case abandoned
    
    case cancelled
    
    case restricted
    
    case timeout
    
    case unknown
    
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
        case .authorized:   return "AUTHORIZED"
        case .initiated:   return "INITIATED"
        case .inProgress:   return "IN_PROGRESS"
        case .abandoned:   return "ABANDONED"
        case .cancelled:   return "CANCELLED"
        case .restricted:   return "RESTRICTED"
        case .timeout:   return "TIMEDOUT"
        case .unknown:   return "UNKNOWN"

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
        case AuthorizeActionStatus.authorized.stringValue:  self = .authorized
        case AuthorizeActionStatus.initiated.stringValue:  self = .initiated
        case AuthorizeActionStatus.inProgress.stringValue:  self = .inProgress
        case AuthorizeActionStatus.abandoned.stringValue:  self = .abandoned
        case AuthorizeActionStatus.cancelled.stringValue:  self = .cancelled
        case AuthorizeActionStatus.restricted.stringValue:  self = .restricted
        case AuthorizeActionStatus.timeout.stringValue:  self = .timeout
        case AuthorizeActionStatus.unknown.stringValue:  self = .unknown
            
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
