//
//  CardScannerViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol CardScannerViewControllerDelegate: ClassProtocol {
    
    func cardScannerController(_ scannerController: CardScannerViewController, didScan cardNumber: String?, expirationDate: ExpirationDate?, cvv: String?, cardholderName: String?)
}
