//
//  CardScannerViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol CardScannerViewControllerDelegate: ClassProtocol {
    
    func cardScannerController(_ scannerController: CardScannerViewController, didScan cardNumber: String?, expirationDate: ExpirationDate?, cvv: String?, cardholderName: String?)
}
