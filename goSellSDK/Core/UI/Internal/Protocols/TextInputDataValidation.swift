//
//  TextInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol TextInputDataValidation: DataValidation {
    
    var textInputFieldText: String { get }
    func updateSpecificInputFieldAttributes()
}
