//
//  PayButtonInternalImplementation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol PayButtonInternalImplementation: PayButtonProtocol, SessionProtocol, TapButtonDelegate {
	
	var session:	InternalSession	{ get }
    var uiElement:	PayButtonUI?	{ get }
    
    func updateDisplayedState()
}

internal extension PayButtonInternalImplementation {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var canBeHighlighted: Bool {
        
        return !PaymentDataManager.shared.isExecutingAPICalls
    }
    
    // MARK: Methods
	
	internal func updateAppearance() {
		
		let mode = self.session.dataSource?.mode ?? .default
		let type: TapButtonStyle.ButtonType
		
		switch mode {
			
		case .purchase, .authorizeCapture:
			
			type = .pay
			self.updateDisplayedAmount()
			
		case .cardSaving:
			
			type = .save
			self.uiElement?.forceDisabled = false
			self.uiElement?.setLocalizedText(.btn_save_title)
		}
		
		self.uiElement?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == type })!
	}
	
    internal func updateDisplayedAmount() {
		
		var amountedCurrency: AmountedCurrency?
		
		if let amount = self.session.calculateDisplayedAmount(), let currency = self.session.dataSource?.currency {
			
			amountedCurrency = AmountedCurrency(currency, amount.decimalValue)
		}
		else {
			
			amountedCurrency = nil
		}
		
		self.uiElement?.amount = amountedCurrency
    }
	
    internal func buttonTouchUpInside() {
		
		self.session.start()
    }
	
	internal func securityButtonTouchUpInside() {
		
		self.buttonTouchUpInside()
	}
}
