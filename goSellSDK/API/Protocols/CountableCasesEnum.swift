//
//  CountableCasesEnum.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Represents an enum that has non-endless number of cases.
public protocol CountableCasesEnum {
    
    // MARK: Properties
    
    /// All enum cases.
    static var all: [Self] { get }
}
