//
//  PaymentProcess.AddressInputHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol AddressInputHandlerInterface {
	
	func prepareAddressInputController(_ addressInputController: AddressInputViewController)
}

internal extension Process {
	
	final class AddressInputHandler: AddressInputHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface

		// MARK: Methods

		internal init(process: ProcessInterface) {

			self.process = process
		}

		internal func prepareAddressInputController(_ addressInputController: AddressInputViewController) {

			guard let cardInputCellViewModel = self.process.viewModelsHandlerInterface.cellModels(of: CardInputTableViewCellModel.self).first else { return }
			guard let validator = cardInputCellViewModel.validator(of: .addressOnCard) as? CardAddressValidator else { return }

			addressInputController.setValidator(validator)
		}
	}
}
