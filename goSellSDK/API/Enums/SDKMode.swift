//
//  SDKMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Enum defining SDK mode.
@objc public enum SDKMode: Int {
    
    /// Sandbox mode.
    @objc(Sandbox)      case sandbox
    
    /// Production mode.
    @objc(Production)   case production
}

// MARK: - CountableCasesEnum
extension SDKMode: CountableCasesEnum {
    
    public static let all: [SDKMode] = [.sandbox, .production]
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
