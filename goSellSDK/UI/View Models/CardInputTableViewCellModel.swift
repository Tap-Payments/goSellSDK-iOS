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
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate

/// View model that handles manual card input table view cell.
internal class CardInputTableViewCellModel: PaymentOptionTableCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardInputTableViewCell?
    
    internal var paymentOptions: [PaymentOption] = [] {
        
        didSet {
            
            self.updatePaymentOptions()
        }
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
    
    internal lazy var cardDataValidators: [CardValidator] = []
    
    internal var definedCardBrand: BrandWithScheme?
    
    internal lazy var inputData: [ValidationType: Any?] = [:]
    
    internal override var isReadyForPayment: Bool {
        
        return (self.requiredCardDataValidators.filter { !$0.isDataValid }).count == 0
    }
    
    internal override var affectsPayButtonState: Bool {
        
        return true
    }
    
    internal override var initiatesPaymentOnSelection: Bool {
        
        return false
    }
    
    internal var binData: BINResponse? {
        
        didSet {
            
            if let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator, let country = self.binData?.country, addressValidator.country == nil {
                
                addressValidator.country = country
            }

            if let cardNumberValidator = self.validator(of: .cardNumber) as? CardNumberValidator {
                
                cardNumberValidator.update(withRemoteBINData: self.binData)
            }
            
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
        
        let address = self.displaysAddressFields ? (self.validator(of: .addressOnCard) as? CardAddressValidator)?.address : nil
        
        let result = CreateTokenCard(number:            number,
                                     expirationMonth:   expirationDate.monthString,
                                     expirationYear:    expirationDate.yearString,
                                     cvc:               cvv.0,
                                     cardholderName:    name,
                                     address:           address)
        
        return result
    }
    
    internal var showsSaveCardSection: Bool {
        
        guard let permissions = SettingsDataManager.shared.settings?.permissions else {
            
            fatalError("Should never reach here, because settings are not loaded and SDK not initialized.")
        }
        return permissions.contains(.merchantCheckout)
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
    
    internal override var paymentOption: PaymentOption? {
        
        return self.selectedPaymentOption
    }
    
    // MARK: Methods
    
    internal required init(indexPath: IndexPath, paymentOptions: [PaymentOption]) {
        
        let iconURLs = paymentOptions.map { $0.imageURL }
        
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.displayedTableViewCellModels = self.tableViewCellModels
        super.init(indexPath: indexPath)
        
        self.paymentOptions = paymentOptions
        
        if self.isScanButtonVisible {
            
            CardIOUtilities.preload()
        }
    }
    
    internal func connectionFinished() {
        
        self.cell?.bindContent()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var requiredCardDataValidators: [CardValidator] {
        
        if self.displaysAddressFields {
            
            return self.cardDataValidators
        }
        else {
            
            return self.cardDataValidators.filter { $0.validationType != .addressOnCard }
        }
    }
    
    private var cardAddressValidatorHasInputData: Bool {
        
        let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
        let hasInputData = addressValidator?.hasInputDataForCurrentAddressFormat ?? false
        
        return hasInputData
    }
    
    private lazy var iconsTableViewHandler: CardInputTableViewCellModelTableViewHandler = CardInputTableViewCellModelTableViewHandler(model: self)
    
    // MARK: Methods
    
    private func updatePaymentOptions() {
        
        let iconURLs = self.paymentOptions.map { $0.imageURL }
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.updateDisplayedTableViewCellModels()
    }
}

// MARK: - SingleCellModel
extension CardInputTableViewCellModel: SingleCellModel {}

// MARK: - DynamicLayoutCellModel
extension CardInputTableViewCellModel: DynamicLayoutTableViewCellModel {}

// MARK: - CardInputTableViewCellLoading
extension CardInputTableViewCellModel: CardInputTableViewCellLoading {
    
    internal var displaysAddressFields: Bool {
        
        return self.binData?.isAddressRequired ?? false
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
    
    internal var addressOnCardArrowImage: UIImage {
        
        return Theme.current.settings.generalImages.arrowRight
    }
    
    internal var scanButtonImage: UIImage {
        
        return Theme.current.settings.cardInputFieldsSettings.scanIcon
    }
    
    internal var isScanButtonVisible: Bool {
        
        return CardIOUtilities.canReadCardWithCamera() && TapApplicationPlistInfo.shared.hasUsageDescription(for: .camera)
    }
    
    internal var tableViewHandler: UITableViewDataSource & UITableViewDelegate {
        
        return self.iconsTableViewHandler
    }
}
