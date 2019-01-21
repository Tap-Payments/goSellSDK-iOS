//
//  PayButtonUI.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIView.UIView

internal class PayButtonUI: TapButton {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override class var nibName: String {
        
        return TapButton.tap_className
    }
    
    internal var amount: AmountedCurrency? {
        
        didSet {
            
            self.updateDisplayedStateAndAmount()
        }
    }
    
    // MARK: Methods
	
	internal override func willMove(toSuperview newSuperview: UIView?) {
		
		super.willMove(toSuperview: newSuperview)
		
		self.localizationChanged()
		if newSuperview == nil {
			
			self.stopMonitoringLocalizationChanges()
		}
		else {
			
			self.startMonitoringLocalizationChanges()
		}
	}
	
    internal func updateDisplayedStateAndAmount() {
        
        guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
            
            self.setLocalizedText(.btn_pay_title_generic)
            self.forceDisabled = true
            
            return
        }
        
        let amountString = CurrencyFormatter.shared.format(displayedAmount)
		self.setLocalizedText(.btn_pay_title_amount, amountString)
		
        self.forceDisabled = false
    }
	
    // MARK: - Private -
    // MARK: Methods
    
    private func setTitle(_ title: String, forceDisabled: Bool) {
        
        self.forceDisabled = forceDisabled
        self.setTitle(title)
    }
}

// MARK: - LocalizationObserver
extension PayButtonUI: LocalizationObserver {
	
	internal func localizationChanged() {
		
		self.updateDisplayedStateAndAmount()
	}
}
