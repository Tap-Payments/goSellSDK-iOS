//
//  TapURLModel.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// URL model
///
/// - array: Array URL model.
/// - dictionary: Dictionary URL model.
public enum TapURLModel {

    case array(parameters: [CustomStringConvertible])
    case dictionary(parameters: [String: Any])
}
