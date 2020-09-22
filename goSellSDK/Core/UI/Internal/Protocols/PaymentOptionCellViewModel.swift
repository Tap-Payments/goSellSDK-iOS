//
//  PaymentOptionCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol PaymentOptionCellViewModel: ClassProtocol {
    
    // MARK: Properties
    
    var paymentOption: PaymentOption? { get }
    
    var isSelected: Bool { get set }
    
    var indexPathOfCellToSelect: IndexPath? { get }
    
    var isReadyForPayment: Bool { get }
    
    var affectsPayButtonState: Bool { get }
    
    var initiatesPaymentOnSelection: Bool { get }
	
	var errorCode: ErrorCode? { get }
}

