//
//  SDKMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Enum defining SDK mode.
@objc public enum SDKMode: Int, CaseIterable {
    
    /// Sandbox mode.
    @objc(Sandbox)      case sandbox
    
    /// Production mode.
    @objc(Production)   case production
}

// MARK: - CustomStringConvertible
extension SDKMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .sandbox:      return "Sandbox"
        case .production:   return "Production"

        }
    }
}
