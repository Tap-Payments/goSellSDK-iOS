//
//  PaymentDataManager+CardScanning.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func prepareCardScannerController(_ cardScannerController: CardScannerViewController) {
        
        cardScannerController.delegate = self
    }
}

// MARK: - CardScannerViewControllerDelegate
extension PaymentDataManager: CardScannerViewControllerDelegate {
    
    internal func cardScannerController(_ scannerController: CardScannerViewController, didScan cardNumber: String?, expirationDate: ExpirationDate?, cvv: String?, cardholderName: String?) {
        
        guard let cardInputCellViewModel = self.cellModels(of: CardInputTableViewCellModel.self).first else {
            
            fatalError("How did you open card scanner screen?")
        }
        
        cardInputCellViewModel.update(withScanned: cardNumber, expirationDate: expirationDate, cvv: cvv, cardholderName: cardholderName)
    }
}
