//
//  ChargeStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum ChargeStatus: String, Decodable {
    
    case initiated      = "INITIATED"
    case otpRequired    = "OTP_REQUIRED"
    case inProgress     = "IN_PROGRESS"
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
        case .otpRequired:  return "OTP code required"
        case .inProgress:   return "In Progress"
        case .cancelled:    return "Cancelled"
        case .failed:       return "Failed"
        case .declined:     return "Declined"
        case .restricted:   return "Restricted"
        case .captured:     return "Captured"
        case .void:         return "Void"

        }
    }
}
