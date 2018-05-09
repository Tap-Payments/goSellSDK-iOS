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

internal class CardScannerViewController: UIViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate.
    internal weak var delegate: CardScannerViewControllerDelegate?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var navigationView: TapNavigationView? {
        
        didSet {
            
            self.navigationView?.delegate = self
        }
    }
    
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
    
    // MARK: Methods
    
    private func dismiss() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TapNavigationViewDelegate
extension CardScannerViewController: TapNavigationViewDelegate {
    
    internal func navigationViewBackButtonClicked(_ navigationView: TapNavigationView) {
        
        self.dismiss()
    }
}

// MARK: - CardIOViewDelegate
extension CardScannerViewController: CardIOViewDelegate {
    
    internal func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        
        let cardNumber = cardInfo.cardNumber
        
        let expiryMonth = cardInfo.expiryMonth
        let expiryYear = cardInfo.expiryYear % 100
        
        var expirationDate: ExpirationDate? = nil
        if expiryMonth > 0 && expiryYear > 0 {
            
            expirationDate = ExpirationDate(month: Int(expiryMonth), year: Int(expiryYear))
        }
        
        self.delegate?.cardScannerController(self, didScan: cardNumber, expirationDate: expirationDate, cvv: cardInfo.cvv, cardholderName: cardInfo.cardholderName)
        
        self.dismiss()
    }
}
