//
//  FeeType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Fee type.
///
/// - percetage: Fee in percents
/// - fixed: Fixed amount fee.
internal enum FeeType: String, Decodable {
    
    case percetage = "P"
    case fixed = "F"
}
