//
//  PaymentDataManager+PaymentOptionsSelection.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
        
        return self.ableToBeSelectedPaymentOptionCellModels.first { $0.isSelected }
    }
    
    // MARK: Methods
    
    internal func deselectAllPaymentOptionsModels() {
        
        self.ableToBeSelectedPaymentOptionCellModels.forEach { $0.isSelected = false }
        self.updatePayButtonStateAndAmount()
    }
    
    internal func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {
        
        if self.isInDeleteSavedCardsMode && model is CardCollectionViewCellModel {
            
            self.deselectAllPaymentOptionsModels()
            self.updatePayButtonStateAndAmount()
            return
        }
        else if self.isInDeleteSavedCardsMode {
            
            self.isInDeleteSavedCardsMode = false
        }
        
        let allModels = self.ableToBeSelectedPaymentOptionCellModels
        
        allModels.forEach { $0.isSelected = $0 === model }
        
        self.lastSelectedPaymentOption = model
        
        self.updatePayButtonStateAndAmount()
        
        if model.initiatesPaymentOnSelection {
            
            self.startPaymentProcess(with: model)
            self.deselectPaymentOption(model)
        }
    }
    
    internal func deselectPaymentOption(_ model: PaymentOptionCellViewModel) {
        
        self.lastSelectedPaymentOption = nil
        model.isSelected = false
        
        self.updatePayButtonStateAndAmount()
    }
    
    internal func restorePaymentOptionSelection() {
        
        if let nonnullLastSelectedPaymentOption = self.lastSelectedPaymentOption {
            
            self.deselectAllPaymentOptionsModels(except: nonnullLastSelectedPaymentOption)
        }
        else {
            
            let paymentOptionsModels = self.cellModels(of: PaymentOptionTableCellViewModel.self)
            paymentOptionsModels.forEach { $0.isSelected = false }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var ableToBeSelectedPaymentOptionCellModels: [PaymentOptionCellViewModel] {
        
        let topLevelModels = (self.paymentOptionsScreenCellViewModels.filter { $0 is PaymentOptionCellViewModel } as? [PaymentOptionCellViewModel]) ?? []
        let savedCardsModels = self.cellModels(of: CardsContainerTableViewCellModel.self).first?.collectionViewCellModels ?? []
        
        return topLevelModels + savedCardsModels
    }
}
