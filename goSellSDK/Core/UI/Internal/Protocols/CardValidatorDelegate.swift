//
//  CardValidatorDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol CardValidatorDelegate: ClassProtocol {
    
    func validationStateChanged(to valid: Bool, on type: ValidationType)
    
    func cardValidator(_ validator: CardValidator, inputDataChanged data: Any?)
}
