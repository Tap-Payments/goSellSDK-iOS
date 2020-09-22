//
//  DataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import class UIKit.UITextField.UITextField

/// Data validation protocol.
internal protocol DataValidation: ClassProtocol {
    
    var validationType: ValidationType { get }
    
    var isDataValid: Bool { get }
    
    func validate()
}
