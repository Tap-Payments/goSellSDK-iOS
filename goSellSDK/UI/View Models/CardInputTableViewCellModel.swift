//
//  CardInputTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    CardIO.CardIOUtilities.CardIOUtilities
import class    TapApplication.TapApplicationPlistInfo
import enum     TapCardValidator.CardBrand
import struct   TapCardValidator.DefinedCardBrand
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIImage.UIImage

internal class CardInputTableViewCellModel: PaymentOptionCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardInputTableViewCell?
    
    internal var paymentOptions: [PaymentOption] = [] {
        
        didSet {
            
            self.updatePaymentOptions()
        }
    }
    
    internal let scanButtonVisible = CardIOUtilities.canReadCardWithCamera() && TapApplicationPlistInfo.shared.hasUsageDescription(for: .camera)
    
    internal var scanButtonImage: UIImage {
        
        return Theme.current.settings.cardInputFieldsSettings.scanIcon
    }
    
    internal var displaysAddressFields: Bool {
        
        return self.binData?.isAddressRequired ?? false
    }
    
    internal var addressOnCardText: String {
        
        let hasInputData = self.cardAddressValidatorHasInputData
        
        if hasInputData {
            
            let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
            return addressValidator?.displayText ?? "Address on Card"
        }
        else {
            
            return "Address on Card"
        }
    }
    
    internal var addressOnCardTextColor: UIColor {
        
        let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
        let hasInputData = addressValidator?.hasInputDataForCurrentAddressFormat ?? false
        let valid = addressValidator?.isDataValid ?? false
        
        let cardInputSettings = Theme.current.settings.cardInputFieldsSettings
        
        let settings = hasInputData ? (valid ? cardInputSettings.valid : cardInputSettings.invalid) : cardInputSettings.placeholder
        return settings.color
    }
    
    internal var addressOnCardTextFont: UIFont {
        
        let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
        let hasInputData = addressValidator?.hasInputDataForCurrentAddressFormat ?? false
        let valid = addressValidator?.isDataValid ?? false
        
        let cardInputSettings = Theme.current.settings.cardInputFieldsSettings
        
        let settings = hasInputData ? (valid ? cardInputSettings.valid : cardInputSettings.invalid) : cardInputSettings.placeholder
        return settings.font
    }
    
    internal var addressOnCardArrowImage: UIImage {
        
        return Theme.current.settings.generalImages.arrowRight
    }
    
    internal var tableViewCellModels: [ImageTableViewCellModel]
    internal var displayedTableViewCellModels: [ImageTableViewCellModel] {
        
        didSet {
            
            guard self.displayedTableViewCellModels != oldValue else {
                
                return
            }
            
            self.updateCell(animated: true)
        }
    }
    
    internal lazy var tableViewHandler: CardInputTableViewCellModelTableViewHandler = CardInputTableViewCellModelTableViewHandler(model: self)
    
    internal lazy var cardDataValidators: [CardValidator] = []
    
    internal var definedCardBrand: DefinedCardBrand?
    
    internal lazy var inputData: [ValidationType: Any?] = [:]
    
    internal override var isReadyForPayment: Bool {
        
        return (self.cardDataValidators.filter { !$0.isDataValid }).count == 0
    }
    
    internal override var affectsPayButtonState: Bool {
        
        return true
    }
    
    internal override var initiatesPaymentOnSelection: Bool {
        
        return false
    }
    
    internal var binData: BINResponse? {
        
        didSet {
            
            (self.validator(of: .addressOnCard) as? CardAddressValidator)?.binInformation = self.binData
            self.updateCell(animated: true)
        }
    }
    
    internal var card: CreateTokenCard? {
        
        guard
            
            let number          = self.inputData[.cardNumber]       as? String,
            let expirationDate  = self.inputData[.expirationDate]   as? ExpirationDate,
            let cvv             = self.inputData[.cvv]              as? (String, CardBrand),
            let name            = self.inputData[.nameOnCard]       as? String
        
        else { return nil }
        
        var address: Address?
        if self.displaysAddressFields {
            
            guard let storedAddress = self.inputData[.addressOnCard] as? Address else { return nil }
            
            address = storedAddress
        }
        
        let result = CreateTokenCard(number:            number,
                                     expirationMonth:   expirationDate.monthString,
                                     expirationYear:    expirationDate.yearString,
                                     cvc:               cvv.0,
                                     cardholderName:    name,
                                     address:           address)
        
        return result
    }
    
    internal var shouldSaveCard: Bool {
        
        return (self.inputData[.saveCard] as? Bool) ?? false
    }
    
    internal var selectedPaymentOption: PaymentOption? {
        
        guard let cardBrand = (self.inputData[.cvv] as? (String, CardBrand))?.1 else { return nil }
        
        let possibleOptions = self.possiblePaymentOptions
        
        let result = possibleOptions.first { $0.supportedCardBrands.contains(cardBrand) }
        return result
    }
    
    // MARK: Methods
    
    internal required init(indexPath: IndexPath, paymentOptions: [PaymentOption]) {
        
        let iconURLs = paymentOptions.map { $0.imageURL }
        
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.displayedTableViewCellModels = self.tableViewCellModels
        super.init(indexPath: indexPath)
        
        self.paymentOptions = paymentOptions
        
        if self.scanButtonVisible {
            
            CardIOUtilities.preload()
        }
    }
    
    internal func connectionFinished() {
        
        self.cell?.bindContent()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var cardAddressValidatorHasInputData: Bool {
        
        let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
        let hasInputData = addressValidator?.hasInputDataForCurrentAddressFormat ?? false
        
        return hasInputData
    }
    
    // MARK: Methods
    
    private func updatePaymentOptions() {
        
        let iconURLs = self.paymentOptions.map { $0.imageURL }
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.updateDisplayedCollectionViewCellModels()
    }
}

// MARK: - SingleCellModel
extension CardInputTableViewCellModel: SingleCellModel {}

// MARK: - DynamicLayoutCellModel
extension CardInputTableViewCellModel: DynamicLayoutCellModel {}
