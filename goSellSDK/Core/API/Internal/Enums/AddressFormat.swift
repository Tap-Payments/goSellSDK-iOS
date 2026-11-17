//
//  AddressFormat.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// Address format enum.
///
/// - a: Format A.
/// - b: Format B.
/// - c: Format C.
internal enum AddressFormat: String, Codable {
    
    case a = "FORMAT_A"
    case b = "FORMAT_B"
    case c = "FORMAT_C"
}
