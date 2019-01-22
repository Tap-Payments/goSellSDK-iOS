//
//  PaymentProcess.SaveProcessButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal final class SaveProcessButtonHandler: SaveButtonHandler, ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
			super.init()
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
	}
}
