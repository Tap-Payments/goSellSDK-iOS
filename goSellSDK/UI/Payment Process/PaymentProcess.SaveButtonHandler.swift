//
//  PaymentProcess.SaveButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal class SaveButtonHandler: TapButtonHandler {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal override var canButtonBeHighlighted: Bool {
			
			return true
		}
		
		// MARK: Methods
		
		internal override func updateButtonState() {
			
			super.updateButtonState()
			
			self.button?.setLocalizedText(.btn_save_title)
			self.button?.forceDisabled = false
		}
	}
}
