//
//  CardBrandChangeReporting.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import struct TapCardValidator.DefinedCardBrand

internal protocol CardBrandChangeReporting: ClassProtocol {
    
    func cardNumberValidator(_ validator: CardNumberValidator, cardNumberInputChanged cardNumber: String)
    func recognizedCardBrandChanged(_ definedCardBrand: DefinedCardBrand)
}
