//
//  SourceIdentifier.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Static source identifier.
///
/// - KNET: KNET source identifier.
/// - BENEFIT: Benefit source identifier.
/// - SADAD: Sadad source identifier.
/// - FAWRY: Fawry source identifier.
internal enum SourceIdentifier {
    
    /// KNET source identifier.
    case KNET
    
    /// Benefit source identifier.
    case BENEFIT
    
    /// Sadad source identifier.
    case SADAD
    
    /// Fawry source identifier.
    case FAWRY
    
    internal var stringValue: String {
        
        switch self {
            
        case .KNET:
            
            return Constants.knetIdentifier
            
        case .BENEFIT:
            
            return Constants.benefitIdentifier
            
        case .SADAD:
            
            return Constants.sadadIdentifier
            
        case .FAWRY:
            
            return Constants.fawryIdentifier
        }
    }
    
    private struct Constants {
        
        fileprivate static let knetIdentifier       = "src_kw.knet"
        fileprivate static let benefitIdentifier    = "src_bh.benefit"
        fileprivate static let sadadIdentifier      = "src_sa.sadad"
        fileprivate static let fawryIdentifier      = "src_eg.fawry"
        
        @available(*, unavailable) private init() {
            
            fatalError("This type cannot be instantiated.")
        }
    }
}
