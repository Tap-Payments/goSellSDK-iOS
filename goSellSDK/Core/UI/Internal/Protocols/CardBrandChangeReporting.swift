//
//  CardBrandChangeReporting.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import protocol TapAdditionsKitV2.ClassProtocol

internal protocol CardBrandChangeReporting: ClassProtocol {
    
    func cardNumberValidator(_ validator: CardNumberValidator, cardNumberInputChanged cardNumber: String)
    func recognizedCardBrandChanged(_ definedCardBrand: BrandWithScheme)
}
