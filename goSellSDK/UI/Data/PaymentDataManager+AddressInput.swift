//
//  PaymentDataManager+AddressInput.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func prepareAddressInputController(_ addressInputController: AddressInputViewController) {
        
        guard let cardInputCellViewModel = self.cellModels(of: CardInputTableViewCellModel.self).first else { return }
        guard let validator = cardInputCellViewModel.validator(of: .addressOnCard) as? CardAddressValidator else { return }
        
        addressInputController.setValidator(validator)
    }
}
