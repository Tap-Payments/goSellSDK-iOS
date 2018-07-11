//
//  ChargeStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum ChargeStatus: String, Decodable {
    
    case initiated      = "INITIATED"
    case inProgress     = "IN_PROGRESS"
    case abandoned      = "ABANDONED"
    case cancelled      = "CANCELLED"
    case failed         = "FAILED"
    case declined       = "DECLINED"
    case restricted     = "RESTRICTED"
    case captured       = "CAPTURED"
    case void           = "VOID"
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var localizedDescription: String {
        
        switch self {
            
        case .initiated:    return "Initiated"
        case .inProgress:   return "In Progress"
        case .abandoned:    return "Abandoned"
        case .cancelled:    return "Cancelled"
        case .failed:       return "Failed"
        case .declined:     return "Declined"
        case .restricted:   return "Restricted"
        case .captured:     return "Captured"
        case .void:         return "Void"

        }
    }
}
