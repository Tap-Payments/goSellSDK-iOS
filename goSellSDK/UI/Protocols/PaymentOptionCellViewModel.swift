//
//  PaymentOptionCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol PaymentOptionCellViewModel: ClassProtocol {
    
    // MARK: Properties
    
    var paymentOption: PaymentOption? { get }
    
    var isSelected: Bool { get set }
    
    var indexPathOfCellToSelect: IndexPath? { get }
    
    var isReadyForPayment: Bool { get }
    
    var affectsPayButtonState: Bool { get }
    
    var initiatesPaymentOnSelection: Bool { get }
}

