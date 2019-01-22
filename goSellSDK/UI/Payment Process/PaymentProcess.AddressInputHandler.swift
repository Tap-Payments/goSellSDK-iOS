//
//  PaymentProcess.AddressInputHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal class AddressInputHandler: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func prepareAddressInputController(_ addressInputController: AddressInputViewController) {
			
			guard let cardInputCellViewModel = self.process.viewModelsHandler.cellModels(of: CardInputTableViewCellModel.self).first else { return }
			guard let validator = cardInputCellViewModel.validator(of: .addressOnCard) as? CardAddressValidator else { return }
			
			addressInputController.setValidator(validator)
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
	}
}
