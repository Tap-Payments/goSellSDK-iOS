//
//  BillingAddressField+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension BillingAddressField {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal func canBeFilled(with data: Any?, considering specification: AddressField) -> Bool {

        switch specification.type {

        case .dropdown: return true

        case .textInput(let inputType):

            if data == nil {

                return !self.isRequired
            }

            guard let string = data as? String else { return false }
            if self.isRequired && string.isEmpty { return false }

            switch inputType {

            case .digits:

                return string.containsOnlyDigits

            case .text:

                return true
            }
        }
    }
}
