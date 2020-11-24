//
//  CardScannerViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
#if canImport(CardIO)
import CardIO
#endif
import struct	CoreGraphics.CGGeometry.CGSize
import enum		UIKit.UIApplication.UIStatusBarStyle
import class	UIKit.UIScreen.UIScreen
import class	UIKit.UIViewController.UIViewController

internal class CardScannerViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[.fullscreen].uiStatusBarStyle
	}
	
	internal override var preferredContentSize: CGSize {
		
		get {
			
			return UIScreen.main.bounds.size
		}
		set {
			
			super.preferredContentSize = UIScreen.main.bounds.size
		}
	}
    
    /// Delegate.
    internal weak var delegate: CardScannerViewControllerDelegate?
    
    // MARK: Methods
	
    // MARK: - Private -
    // MARK: Properties
    #if canImport(CardIO)
    @IBOutlet private weak var scannerView: CardIOView? {
        
        didSet {
            
            self.scannerView?.delegate                      = self
            self.scannerView?.scanExpiry                    = true
            self.scannerView?.scannedImageDuration          = 0.0
            self.scannerView?.hideCardIOLogo                = true
            self.scannerView?.languageOrLocale              = LocalizationManager.shared.selectedLanguage
            self.scannerView?.detectionMode                 = .cardImageAndNumber
            self.scannerView?.guideColor                    = .tap_hex("#2ACE00")
            self.scannerView?.allowFreelyRotatingCardGuide  = true
        }
    }
    #endif
}

// MARK: - TapNavigationView.DataSource
extension CardScannerViewController: TapNavigationView.DataSource {
	
	internal func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool {
		
		return (self.navigationController?.viewControllers.count ?? 0) > 1
	}
	
	internal func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image? {
		
		return nil
	}
	
	internal func navigationViewIcon(for navigationView: TapNavigationView) -> Image? {
		
		if let icon = Theme.current.paymentOptionsCellStyle.card.scanIcon {
			
			return .ready(icon)
		}
		else {
			
			return nil
		}
	}
	
	internal func navigationViewTitle(for navigationView: TapNavigationView) -> String? {
		
		return LocalizationManager.shared.localizedString(for: .card_scanning_screen_title)
	}
}

#if canImport(CardIO)
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
#endif
