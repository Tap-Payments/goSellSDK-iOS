//
//  CardScannerViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class CardIO.CardIOCreditCardInfo.CardIOCreditCardInfo
import class CardIO.CardIOView.CardIOView
import protocol CardIO.CardIOViewDelegate.CardIOViewDelegate
import class UIKit.UIViewController.UIViewController

internal class CardScannerViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate.
    internal weak var delegate: CardScannerViewControllerDelegate?
    
    // MARK: Methods
    
    internal override func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
        
        super.headerNavigationViewLoaded(headerView)
        
        headerView.iconImage = Theme.current.settings.cardInputFieldsSettings.scanIcon
        headerView.title = "Scanning Card"
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var scannerView: CardIOView? {
        
        didSet {
            
            self.scannerView?.delegate = self
            self.scannerView?.scanExpiry = true
            self.scannerView?.scannedImageDuration = 0.0
            self.scannerView?.hideCardIOLogo = true
            self.scannerView?.detectionMode = .cardImageAndNumber
            self.scannerView?.allowFreelyRotatingCardGuide = true
        }
    }
}

// MARK: - CardIOViewDelegate
extension CardScannerViewController: CardIOViewDelegate {
    
    internal func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        
        guard let nonnullCardInfo = cardInfo else { return }
        
        let cardNumber = nonnullCardInfo.cardNumber
        
        let expiryMonth = nonnullCardInfo.expiryMonth
        let expiryYear = nonnullCardInfo.expiryYear % 100
        
        var expirationDate: ExpirationDate? = nil
        if expiryMonth > 0 && expiryYear > 0 {
            
            expirationDate = ExpirationDate(month: Int(expiryMonth), year: Int(expiryYear))
        }
        
        self.delegate?.cardScannerController(self,
                                             didScan: cardNumber,
                                             expirationDate: expirationDate,
                                             cvv: nonnullCardInfo.cvv,
                                             cardholderName: nonnullCardInfo.cardholderName)
        
        self.pop()
    }
}
