//
//  CardInputTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
#if canImport(CardIO)
import class    CardIO.CardIOUtilities.CardIOUtilities
#endif
import class    TapApplicationV2.TapApplicationPlistInfo
import struct	TapBundleLocalization.LocalizationKey
import enum     TapCardVlidatorKit_iOS.CardBrand
import struct   TapCardVlidatorKit_iOS.DefinedCardBrand
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIImage.UIImage
import class	UIKit.UIResponder.UIResponder
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class	UIKit.UIView.UIView
import struct PassKit.PKPaymentNetwork
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
		
		guard self.cell?.isContentBinded ?? false else { return false }
		
		return (self.requiredCardDataValidators.filter { !$0.isDataValid }).count == 0
	}
	
	internal override var affectsPayButtonState: Bool {
		
		return true
	}
	
	internal override var initiatesPaymentOnSelection: Bool {
		
		return false
	}
	
	internal override var errorCode: ErrorCode? {
		
		for validator in self.requiredCardDataValidators {
			
			if let errorCode = validator.errorCode {
				
				return errorCode
			}
		}
		
		return nil
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
        return Permissions.merchantCheckoutAllowed
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
            #if canImport(CardIO)
			CardIOUtilities.preload()
            #endif
		}
		
		self.addObservers()
	}
	
	deinit {
		
		self.removeObservers()
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
	
	private func addObservers() {
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .tap_keyboardWillShowNotificationName, object: nil)
	}
	
	private func removeObservers() {
		
		NotificationCenter.default.removeObserver(self, name: .tap_keyboardWillShowNotificationName, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: Notification?) {
		
		guard let nonnullCell = self.cell, let responder = UIResponder.tap_current as? UIView, responder.isDescendant(of: nonnullCell) else { return }
		
		DispatchQueue.main.async { [weak self] in
			
			guard let strongSelf = self else { return }
			
			strongSelf.tableView?.scrollToRow(at: strongSelf.indexPath, at: .none, animated: true)
		}
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
		
		let cardInputSettings = Theme.current.paymentOptionsCellStyle.card.textInput
		
		let settings = cardInputSettings[hasInputData ? (valid ? .valid : .invalid) : .placeholder]
		return settings.color.color
	}
	
	internal var addressOnCardTextFont: UIFont {
		
		let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
		let hasInputData = addressValidator?.hasInputDataForCurrentAddressFormat ?? false
		let valid = addressValidator?.isDataValid ?? false
		
		let cardInputSettings = Theme.current.paymentOptionsCellStyle.card.textInput
		
		let settings = cardInputSettings[hasInputData ? (valid ? .valid : .invalid) : .placeholder]
		return settings.font.localized
	}
	
	internal var addressOnCardText: String {
		
		let hasInputData = self.cardAddressValidatorHasInputData
		
		if hasInputData {
			
			let addressValidator = self.validator(of: .addressOnCard) as? CardAddressValidator
			return addressValidator?.displayText ?? LocalizationManager.shared.localizedString(for: .card_input_address_on_card_placeholder)
		}
		else {
			
			return LocalizationManager.shared.localizedString(for: .card_input_address_on_card_placeholder)
		}
	}
	
	internal var addressOnCardArrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
	}
	
	internal var scanButtonImage: UIImage {
		
		guard let image = Theme.current.paymentOptionsCellStyle.card.scanIcon else
        {
            guard let imageBackup = UIImage(tap_byCombining: [Theme.current.paymentOptionsCellStyle.card.scanIconFrame, Theme.current.paymentOptionsCellStyle.card.scanIconIcon]) else
            {
                return UIImage()
            }
            return imageBackup
        }
        return image
	}
	
	internal var isScanButtonVisible: Bool {
        #if canImport(CardIO)
            return CardIOUtilities.canReadCardWithCamera() && TapApplicationPlistInfo.shared.hasUsageDescription(for: .camera)
        #else
            return false
        #endif
	}
	
	internal var showsSaveCardSwitch: Bool {
		
		return Process.shared.transactionMode != .cardSaving
	}
	
	internal var tableViewHandler: UITableViewDataSource & UITableViewDelegate {
		
		return self.iconsTableViewHandler
	}
	
	internal var saveCardDescriptionKey: LocalizationKey {
		
		switch Process.shared.transactionMode {
			
		case .purchase, .authorizeCapture, .cardTokenization:
			
			return .save_card_promotion_text
			
		case .cardSaving:
			
			return .saved_cards_usage_description
		}
	}
}
