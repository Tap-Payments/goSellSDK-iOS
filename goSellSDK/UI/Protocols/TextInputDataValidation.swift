//
//  TextInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol TextInputDataValidation: DataValidation {
    
    var textInputFieldText: String { get }
    func updateSpecificInputFieldAttributes()
}
