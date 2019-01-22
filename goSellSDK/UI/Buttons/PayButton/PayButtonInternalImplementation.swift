//
//  PayButtonInternalImplementation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol PayButtonInternalImplementation: PayButtonProtocol, SessionProtocol {
	
	var session:	InternalSession						{ get }
    var uiElement:	TapButton?							{ get }
	var handler:	PaymentProcess.TapButtonHandler?	{ get set }
    
    func updateDisplayedState()
}

internal extension PayButtonInternalImplementation {
    
    // MARK: - Internal -
    // MARK: Methods
	
	internal func updateAppearance() {
		
		if self.updateHandlerIfRequired() {
			
			self.handler?.buttonStyle = self.requiredButtonType
			self.handler?.updateButtonState()
		}
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private var transactionMode: TransactionMode {
		
		let mode = self.session.dataSource?.mode ?? .default
		
		return mode
	}
	
	private var requiredButtonType: TapButtonStyle.ButtonType {
		
		let mode = self.transactionMode
		let type: TapButtonStyle.ButtonType = mode == .cardSaving ? .save : .pay
		
		return type
	}
	
	private var amount: AmountedCurrency? {
		
		let mode = self.transactionMode
		
		guard mode == .purchase || mode == .authorizeCapture else { return nil }
		
		var amountedCurrency: AmountedCurrency?
		
		if let amount = self.session.calculateDisplayedAmount(), let currency = self.session.dataSource?.currency {
			
			amountedCurrency = AmountedCurrency(currency, amount.decimalValue)
		}
		else {
			
			amountedCurrency = nil
		}
		
		return amountedCurrency
	}
	
	private var canSave: Bool {
		
		return PaymentProcess.Validation.canStart(using: self.session)
	}
	
	// MARK: Methods
	
	private func updateHandlerIfRequired() -> Bool {
		
		let type = self.requiredButtonType
		
		switch type {
			
		case .pay:
			
			if let existing = self.handler as? PaymentProcess.PayButtonHandler {
				
				existing.amount = self.amount
				return true
			}
			else {
				
				let payHandler = PaymentProcess.PayButtonHandler()
				payHandler.clickCallback = { self.session.start() }
				payHandler.amount = self.amount
				payHandler.setButton(self.uiElement)
				payHandler.buttonStyle = type
				
				self.handler = payHandler
				
				return false
			}
			
		case .save:
			
			if let existing = self.handler as? PaymentProcess.SaveButtonHandler {
				
				existing.makeButtonEnabled(self.canSave)
				return true
			}
			else {
				
				let saveHandler = PaymentProcess.SaveButtonHandler()
				saveHandler.clickCallback = { self.session.start() }
				saveHandler.setButton(self.uiElement)
				saveHandler.buttonStyle = type
				
				self.handler = saveHandler
				
				return false
			}
			
		case .confirmOTP:
			
			fatalError("Impossible case here.")
		}
	}
}
