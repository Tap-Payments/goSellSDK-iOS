//
//  Process.DataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol	TapAdditionsKitV2.ClassProtocol
import struct	TapAdditionsKitV2.TypeAlias
import enum		TapCardVlidatorKit_iOS.CardBrand
import class	UIKit.UIResponder.UIResponder
import PassKit

internal protocol DataManagerInterface: ClassProtocol {
	
	var selectedCurrency: AmountedCurrency { get }
	var userSelectedCurrency: AmountedCurrency? { get set }
	var transactionCurrency: AmountedCurrency { get }
	var supportedCurrencies: [AmountedCurrency] { get }
	var paymentOptions: [PaymentOption] { get }
	
	var recentCards: [SavedCard] { get }
	
	var currentPaymentOption: PaymentOption? { get }
	var currentPaymentCardBINNumber: String? { get }
	var urlToLoadInWebPaymentController: URL? { get }
	var currentChargeOrAuthorize: ChargeProtocol? { get set }
	var currentVerification: CardVerification? { get }
	
	var isExecutingAPICalls: Bool { get }
	var isCallingPaymentAPI: Bool { get }
	var isLoadingPaymentOptions: Bool { get }
	var isInDeleteSavedCardsMode: Bool { get set }
	var isChargeOrAuthorizeInProgress: Bool { get }
	
	var shouldToggleSaveCardSwitchToOnAutomatically: Bool { get }
	var didToggleSaveCardSwitchToOnAutomatically: Bool { get set }
	
	func loadPaymentOptions(for session: SessionProtocol) -> Bool
	
	func currencySymbol(for currency: Currency) -> String
	func iconURL(for cardBrand: CardBrand, scheme: CardScheme?) -> URL?
	func paymentOption(for savedCard: SavedCard) -> PaymentOption
    func paymentOption(for type: PaymentType) -> PaymentOption
	func paymentOptions(of type: PaymentType) -> [PaymentOption]
	
	func updateUIByRemoving(_ card: SavedCard)
	func paymentCancelled()
	
	var groupWithButtonButtonClickAction: TypeAlias.ArgumentlessClosure? { get }
	
	var paymentOptionsResponse: PaymentOptionsResponse? { get }
	
    func createApplePayRequest() -> PKPaymentRequest
    func canStartApplePayPurchase() -> Bool
    func callApplePayTokenApi(with applePayTokenRequest:CreateTokenWithApplePayRequest, paymentOption:PaymentOption?)
    
	func callChargeOrAuthorizeAPI(with source:						SourceRequest,
								  paymentOption:					PaymentOption,
								  token:							Token?,
								  cardBIN:							String?,
								  saveCard:							Bool?,
								  loader:							LoadingViewSupport?,
								  retryAction:						@escaping TypeAlias.ArgumentlessClosure,
								  alertDismissButtonClickHandler:	TypeAlias.ArgumentlessClosure?)
    
    func callChargeApplePayAPI(for session: SessionProtocol)
	
	func handleChargeOrAuthorizeResponse<T>(_ chargeOrAuthorize: T?,
															error: TapSDKError?,
															retryAction: @escaping TypeAlias.ArgumentlessClosure) where T: ChargeProtocol
	
	func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize:			T?,
															error:							TapSDKError?,
															paymentOption:					PaymentOption,
															cardBIN:						String?,
															retryAction:					@escaping TypeAlias.ArgumentlessClosure,
															alertDismissButtonClickHandler:	TypeAlias.ArgumentlessClosure?)
	
	func handleCardVerificationResponse(_ cardVerification:	CardVerification?,
										error:				TapSDKError?,
										binNumber:			String?,
										retryAction:		@escaping TypeAlias.ArgumentlessClosure)
}

internal extension Process {
	
    class DataManager: NSObject,DataManagerInterface
    {
        
        /**
         The method creates a valid apple pay request to be used inside the apple pay sheet. It will convert TAP payment networks and Merchant items to understandable information by Apple Pay Kit
         - Returns: A PKPaymentRequest that wrapes the merchant's items and Tap's payment networks
         */
        internal func createApplePayRequest() -> PKPaymentRequest
        {
            guard
                
                let dataSource    = self.process.process.externalSession?.dataSource,
                let customer    = dataSource.customer,
                let applePaymentOption:ApplePaymentOptionTableViewCellModel = Process.shared.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel as? ApplePaymentOptionTableViewCellModel else {
                
                fatalError("This case should never happen.")
            }
            
            
            let request = PKPaymentRequest()
            //
            request.supportedNetworks = applePaymentOption.applePayMappedSupportedNetworks
            //request.requiredBillingContactFields = [PKContactField.name,PKContactField.phoneNumber]
            request.merchantCapabilities = [PKMerchantCapability.capability3DS]
            if let session = Process.shared.externalSession?.dataSource
            {
                let countryCode = self.merchnantCountryCode
                
                if let merchantID = session.applePayMerchantID
                {
                    request.merchantIdentifier = merchantID
                }else
                {
                    request.merchantIdentifier = "merchant.tap.gosell"
                }
                request.countryCode = countryCode
            }
            
            
            
            print("Networks \(request.supportedNetworks)")
            request.currencyCode = self.selectedCurrency.currency.isoCode.uppercased()
            request.paymentSummaryItems = []
            let contact:PKContact = PKContact.init()
            contact.name = PersonNameComponents.init()
            
            if let phoneNumber = customer.phoneNumber?.phoneNumber
            {
                contact.phoneNumber = CNPhoneNumber(stringValue:"+\(customer.phoneNumber?.isdNumber ?? "")\(phoneNumber)")
            }
            if let firstName = customer.firstName
            {
                contact.name?.givenName = firstName
            }
            if let lastName = customer.lastName
            {
                contact.name?.familyName = lastName
            }
            request.billingContact = contact
            var totalValue:Decimal = 0
            
            
            /*if let newCurrenself.supportedCurrencies.first(where: { $0.currency == currency })
             {
             
             }
             let currency = nonnullPaymentOptionsResponse.currency
             
             if let amountedCurrency = nonnullPaymentOptionsResponse.supportedCurrenciesAmounts.first(where: { $0.currency == currency }) {
             
             return amountedCurrency
             }
             else {
             
             return nonnullPaymentOptionsResponse.supportedCurrenciesAmounts[0]
             }*/
            
            // Check if items are provided, we need to add them to Apple pay sheet
            if let paymentItems:[PaymentItem] = dataSource.items ?? nil
            {
                for item:PaymentItem in paymentItems
                {
                    var convertedPaymentItemPrice:Decimal = item.totalItemAmount
                    
                    if let userCurrency = self.userSelectedCurrency
                    {
                        convertedPaymentItemPrice = (convertedPaymentItemPrice*(userCurrency.conversionFactor ))
                        
                        //convertedPaymentItemPrice = Decimal(string:CurrencyFormatter.shared.format(AmountedCurrency(userCurrency.currency, convertedPaymentItemPrice),displayCurrency: false)) ?? convertedPaymentItemPrice
                    }
                    request.paymentSummaryItems.append(PKPaymentSummaryItem(label: item.title, amount: NSDecimalNumber(decimal: convertedPaymentItemPrice)))
                    //totalValue += convertedPaymentItemPrice
                    
                }
            }
            
            
            // Check if shipping are provided, we need to add them to Apple pay sheet
            if let shippingItem:[Shipping] = dataSource.shipping ?? nil
            {
                for item:Shipping in shippingItem
                {
                    var convertedPaymentItemPrice:Decimal = item.amount
                    
                    if let userCurrency = self.userSelectedCurrency
                    {
                        convertedPaymentItemPrice = (convertedPaymentItemPrice*(userCurrency.conversionFactor ))
                        
                        //convertedPaymentItemPrice = Decimal(string:CurrencyFormatter.shared.format(AmountedCurrency(userCurrency.currency, convertedPaymentItemPrice),displayCurrency: false)) ?? convertedPaymentItemPrice
                    }
                    request.paymentSummaryItems.append(PKPaymentSummaryItem(label: item.name, amount: NSDecimalNumber(decimal: convertedPaymentItemPrice)))
                    //totalValue += convertedPaymentItemPrice
                    
                }
            }
            
            
            // Check if shipping are provided, we need to add them to Apple pay sheet
            if let taxesItem:[Tax] = dataSource.taxes ?? nil
            {
                for item:Tax in taxesItem
                {
                    var convertedPaymentItemPrice:Decimal = item.amount.value
                    
                    if let userCurrency = self.userSelectedCurrency
                    {
                        convertedPaymentItemPrice = (convertedPaymentItemPrice*(userCurrency.conversionFactor ))
                        
                        //convertedPaymentItemPrice = Decimal(string:CurrencyFormatter.shared.format(AmountedCurrency(userCurrency.currency, convertedPaymentItemPrice),displayCurrency: false)) ?? convertedPaymentItemPrice
                    }
                    if item.amount.type == AmountModificatorType.fixedAmount {
                        request.paymentSummaryItems.append(PKPaymentSummaryItem(label: item.title, amount: NSDecimalNumber(decimal: convertedPaymentItemPrice)))
                    }
                    //totalValue += convertedPaymentItemPrice
                }
            }
            
            
            // Make sure total paid amount matches the original total amount
            if let userCurrency = self.userSelectedCurrency
            {
                totalValue = userCurrency.amount
            }else
            {
                totalValue = transactionCurrency.amount
            }
            
            request.paymentSummaryItems.append(PKPaymentSummaryItem(label: "to \(SettingsDataManager.shared.settings?.merchant.name ?? "Tap Payments")", amount: NSDecimalNumber(decimal: totalValue)))
            
            
            //self.process.dataManagerInterface.transactionCurrency
            
            
            return request
        }
        
        /**
         Use  this method on Apple pay click handler to determine we can start the apple sheet pay or the setup controller
         - Returns: True if we can start the Apple pay sheet and false to indicate we need to another thing
         */
        internal func canStartApplePayPurchase() -> Bool
        {
            //let supportedNetworks = Process.shared.viewModelsHandlerInterface.cardPaymentOptionsCellModel.applePayMappedSupportedNetworks
            for cellViewModel:CellViewModel in Process.shared.viewModelsHandlerInterface.paymentOptionCellViewModels
            {
                if let appleViewModel:ApplePaymentOptionTableViewCellModel = cellViewModel as? ApplePaymentOptionTableViewCellModel
                {
                    if PKPaymentAuthorizationViewController.canMakePayments()
                    {
                        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: appleViewModel.applePayMappedSupportedNetworks)
                        {
                            return true
                        }
                    }
                }
            }
            
            return false
        }
        
        
        internal func callApplePayTokenApi(with applePayTokenRequest:CreateTokenWithApplePayRequest, paymentOption:PaymentOption? = nil)
        {
            self.isExecutingAPICalls = true
            
            APIClient.shared.createToken(with: applePayTokenRequest) { [weak self] (token, error) in
                
                self?.isExecutingAPICalls = false
                
                if let nonnullError = error {
                    
                    if let delegate = Process.shared.externalSession?.delegate
                    {
                        delegate.applePaymentTokenizationFailed?(nonnullError.description, on: Process.shared.externalSession!)
                    }
                }
                else if let nonnullToken = token {
                    if let nonNullPaymentOption = paymentOption {
                        self?.didReceive(nonnullToken, from: applePayTokenRequest, paymentOption: nonNullPaymentOption, saveCard: false)
                    }else {
                        if let delegate = Process.shared.externalSession?.delegate
                        {
                            delegate.applePaymentTokenizationSucceeded?(nonnullToken, on: Process.shared.externalSession!)
                        }
                    }
                }else {
                    if let delegate = Process.shared.externalSession?.delegate
                    {
                        delegate.applePaymentTokenizationFailed?("Cannot create the request.", on: Process.shared.externalSession!)
                    }
                }
            }
        }
        
        
	
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface
		
		internal private(set) var isLoadingPaymentOptions	= false
		internal var isExecutingAPICalls					= false
		
		internal var currentPaymentOption: PaymentOption?
		internal var currentPaymentCardBINNumber: String?
		internal var urlToLoadInWebPaymentController: URL?
		internal var currentChargeOrAuthorize: ChargeProtocol?
		internal var currentVerification: CardVerification?
		
		internal var userSelectedCurrency: AmountedCurrency?
		
		internal var paymentOptionsResponse: PaymentOptionsResponse? {
			
			didSet {
				
				self.process.viewModelsHandlerInterface.updateViewModels()
			}
		}
		
		internal var isInDeleteSavedCardsMode: Bool = false
		
		internal var paymentOptions: [PaymentOption] {
			
			return self.paymentOptionsResponse?.paymentOptions ?? []
		}
		
		internal var supportedCurrencies: [AmountedCurrency] {
			
			fatalError("Should be implemented in subclass.")
		}
		
		internal var groupWithButtonButtonClickAction: TypeAlias.ArgumentlessClosure? {
			
			fatalError("Should be implemented in subclass.")
		}
		
		internal var selectedCurrency: AmountedCurrency {
			
			return self.userSelectedCurrency ?? self.transactionCurrency
		}
		
		internal var transactionCurrency: AmountedCurrency {
			
			guard let nonnullPaymentOptionsResponse = self.paymentOptionsResponse else {
				
				fatalError("Should never reach this place.")
			}
			
			let currency = nonnullPaymentOptionsResponse.currency
			
			if let amountedCurrency = nonnullPaymentOptionsResponse.supportedCurrenciesAmounts.first(where: { $0.currency == currency }) {
				
				return amountedCurrency
			}
			else {
				
				return nonnullPaymentOptionsResponse.supportedCurrenciesAmounts[0]
			}
		}
        
        
        internal var merchnantCountryCode: String {
            
            guard
                let nonnullPaymentOptionsResponse = self.paymentOptionsResponse,
                let merchantCountryCode = nonnullPaymentOptionsResponse.merchantCountryCode else {
                
                return "SA"
            }
            
           return merchantCountryCode
        }
		
		internal var recentCards: [SavedCard] {
			
			return self.paymentOptionsResponse?.savedCards ?? []
		}
		
		internal var isCallingPaymentAPI: Bool {
			
			let activeRoutes = Set(APIClient.shared.activeRequests.compactMap { Route(rawValue: $0.path) })
			let paymentAPIRoutes: Set<Route> = Set([.charges, .authorize, .token, .tokens])
			
			return activeRoutes.intersection(paymentAPIRoutes).count > 0
		}
		
		internal var isChargeOrAuthorizeInProgress: Bool {
			
			fatalError("Should be implemented in subclass.")
		}
		
		internal var shouldToggleSaveCardSwitchToOnAutomatically: Bool {
			
			fatalError("Should be implemented in subclass.")
		}
		
		internal var didToggleSaveCardSwitchToOnAutomatically: Bool = false
		
		internal var requires3DSecure: Bool {
			
			if let permissions = SettingsDataManager.shared.settings?.permissions {
				
				return !permissions.contains(.non3DSecureTransactions)
			}
			else {
				
				return true
			}
		}
		
		// MARK: Methods
		
		internal required init(process: ProcessInterface) {
			
			self.process = process
		}
		
		internal func iconURL(for cardBrand: CardBrand, scheme: CardScheme?) -> URL? {
			
			fatalError("Should be implemented in extension.")
		}
		
		internal func currencySymbol(for currency: Currency) -> String {
			
			fatalError("Should be implemented in extension.")
		}
		
		internal func paymentOption(for savedCard: SavedCard) -> PaymentOption {
			
			fatalError("Should be implemented in subclass.")
		}
        
        internal func paymentOption(for type: PaymentType) -> PaymentOption
        {
            fatalError("Should be implemented in subclass.")
        }
		
		@discardableResult internal func loadPaymentOptions(for session: SessionProtocol) -> Bool {
			
			guard !self.isLoadingPaymentOptions else { return false }
			
			let failureClosure: (String, String) -> Void = { [weak self] (title, message) in
				
				guard let strongSelf = self else { return }
				
				strongSelf.showMissingInformationAlert(with: title, message: message)
			}
			
			guard let request = self.createPaymentOptionsRequest(for: session, callingIfFailed: failureClosure) else { return false }

			self.isLoadingPaymentOptions = true

			session.delegate?.sessionIsStarting?(session)

			APIClient.shared.getPaymentOptions(with: request) { [weak self] (response, error) in

				guard let strongSelf = self else { return }

				strongSelf.isLoadingPaymentOptions = false

				if let nonnullError = error {

					let retryAction: TypeAlias.ArgumentlessClosure = {

						strongSelf.loadPaymentOptions(for: session)
					}

					strongSelf.paymentOptionsResponse = nil
					session.delegate?.sessionHasFailedToStart?(session)

					ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: nil)
				}
				else if let nonnullResponse = response {

					strongSelf.paymentOptionsResponse = nonnullResponse

					strongSelf.process.showPaymentController()

					session.delegate?.sessionHasStarted?(session)
				}
			}
			
			return true
		}
		
		internal func callChargeOrAuthorizeAPI(with source: SourceRequest, paymentOption: PaymentOption, token: Token?, cardBIN: String?, saveCard: Bool?, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
			
			fatalError("Must be implemented in extension")
		}
        
        
        internal func callChargeApplePayAPI(for session: SessionProtocol) {
            fatalError("Must be implemented in extension")
        }
		
		internal func handleChargeOrAuthorizeResponse<T>(_ chargeOrAuthorize: T?, error: TapSDKError?, retryAction: @escaping TypeAlias.ArgumentlessClosure) where T : ChargeProtocol {
			
			fatalError("Must be implemented in extension")
		}
		
		internal func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize: T?, error: TapSDKError?, paymentOption: PaymentOption, cardBIN: String?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
			
			fatalError("Must be implemented in extension")
		}
		
		internal func handleCardVerificationResponse(_ cardVerification: CardVerification?, error: TapSDKError?, binNumber: String?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			fatalError("Must be implemented in extension")
		}
		
		internal func updateUIByRemoving(_ card: SavedCard) {
			
			fatalError("Must be implemented in extension")
		}
		
		internal func paymentCancelled() {
		
			fatalError("Must be implemented in extension")
		}
		
		internal func createPaymentOptionsRequest(for session: SessionProtocol, callingIfFailed closure: (String, String) -> Void) -> PaymentOptionsRequest? {

			fatalError("Should never reach here.")
		}
		
		internal func paymentOptions(of type: PaymentType) -> [PaymentOption] {
			
			return self.paymentOptions.filter { $0.paymentType == type }
		}
		
		internal func callTokenAPI(with request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			UIResponder.tap_current?.resignFirstResponder()
			
			self.isExecutingAPICalls = true
			self.process.buttonHandlerInterface.startButtonLoader()
			
			APIClient.shared.createToken(with: request) { [weak self] (token, error) in
				
				self?.isExecutingAPICalls = false
				
				if let nonnullError = error {
					
					self?.process.buttonHandlerInterface.stopButtonLoader()
					
					let retryAction: TypeAlias.ArgumentlessClosure = {
						
						self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
					}
					
					ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: nil)
				}
				else if let nonnullToken = token {
					
					self?.didReceive(nonnullToken, from: request, paymentOption: paymentOption, saveCard: saveCard)
				}
				else {
					
					self?.process.buttonHandlerInterface.stopButtonLoader()
				}
			}
		}
		
		internal func didReceive(_ token: Token, from request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			fatalError("Needs to be implemented in subclasses")
		}
		
		fileprivate func shouldSaveCard(with token: Token) -> Bool {
			
            guard Permissions.merchantCheckoutAllowed else { return false }
            
			let existingCardFingerprints = self.recentCards.compactMap { $0.fingerprint }.filter { $0.tap_length > 0 }
			if !existingCardFingerprints.contains(token.card.fingerprint) {
				
				return true
			}
			
			return self.process.process.externalSession?.dataSource?.allowsToSaveSameCardMoreThanOnce ?? true
		}
		
		private func showMissingInformationAlert(with title: String, message: String) {
			
			let alert = TapAlertController(title: title, message: message, preferredStyle: .alert)
			let closeAction = TapAlertController.Action(title: "Close", style: .default) { [weak alert] (action) in
				
				alert?.hide()
			}
			
			alert.addAction(closeAction)
			
			alert.show()
		}
	}
	
	final class PaymentDataManager: DataManager {
	
		internal override func createPaymentOptionsRequest(for session: SessionProtocol, callingIfFailed closure: (String, String) -> Void) -> PaymentOptionsRequest? {
			
			guard let nonnullDataSource = session.dataSource else {
				
				closure("Error", "Payment data source cannot be nil.")
				return nil
			}
			
			guard let currency = nonnullDataSource.currency else {
				
				closure("Error", "Currency must be provided.")
				return nil
			}
			
			guard let customer = nonnullDataSource.customer else {
				
				closure("Error", "Customer information must be provided.")
				return nil
			}
			
			let itemsCount = (nonnullDataSource.items ?? [])?.count ?? 0
			guard nonnullDataSource.amount != nil || itemsCount > 0 else {
				
				closure("Error", "Either amount or items should be implemented in payment data source. If items is implemented, number of items should be > 0.")
				return nil
			}
			
			let transactionMode	= nonnullDataSource.mode        ?? .default
			let merchantID		= nonnullDataSource.merchantID	?? nil
			
			let shipping        = nonnullDataSource.shipping    ?? nil
			let taxes           = nonnullDataSource.taxes       ?? nil
			let destinations		= nonnullDataSource.destinations       ?? nil
			let paymentType		= nonnullDataSource.paymentType       ?? nil
            let topup        = nonnullDataSource.topup       ?? nil

			/// the API is using destinationsGroup not destinations
			let destinationsGroup = DestinationGroup(destinations: destinations)
			let paymentRequest = PaymentOptionsRequest(transactionMode: transactionMode,
													   amount:          nonnullDataSource.amount,
													   items:           nonnullDataSource.items ?? [],
													   shipping:        shipping,
													   taxes:           taxes,
													   currency:        currency,
													   merchantID:		merchantID,
													   customer:        customer.identifier,
													   destinationGroup:	destinationsGroup,
													   paymentType:			paymentType,
                                                       topup: topup)
			
			return paymentRequest
		}
		
		internal override var supportedCurrencies: [AmountedCurrency] {
			
			return self.paymentOptionsResponse?.supportedCurrenciesAmounts ?? []
		}
		
		internal override var userSelectedCurrency: AmountedCurrency? {
			
			didSet {
				
				self.process.viewModelsHandlerInterface.currencyChanged()
				self.process.buttonHandlerInterface.updateButtonState()
			}
		}
		
		internal var orderIdentifier: String? {
			
			return self.paymentOptionsResponse?.orderIdentifier
		}
		
		internal override var isInDeleteSavedCardsMode: Bool {
			
			didSet {
				
				guard self.isInDeleteSavedCardsMode != oldValue else { return }
				
				if self.isInDeleteSavedCardsMode {
					
					self.process.viewModelsHandlerInterface.deselectAllPaymentOptionsModels()
				}
				
				self.process.viewModelsHandlerInterface.isInDeleteSavedCardsModeStateChanged()
			}
		}
		
		internal override var isChargeOrAuthorizeInProgress: Bool {
			
			guard let chargeOrAuthorize = self.currentChargeOrAuthorize else { return false }
			
			switch chargeOrAuthorize.status {
				
			case .initiated, .inProgress: return true
			default: return false
				
			}
		}
		
		internal override var shouldToggleSaveCardSwitchToOnAutomatically: Bool {
			
			return (self.process.process.externalSession?.dataSource?.isSaveCardSwitchOnByDefault ?? true) && !self.didToggleSaveCardSwitchToOnAutomatically
		}
		
		internal override var groupWithButtonButtonClickAction: TypeAlias.ArgumentlessClosure? {
			
			return { [weak self] in
				
				self?.isInDeleteSavedCardsMode.toggle()
			}
		}
		
		// MARK: Methods
		
		internal override func paymentOption(for savedCard: SavedCard) -> PaymentOption {
			
			let options = self.paymentOptions.filter { $0.identifier == savedCard.paymentOptionIdentifier }
			guard let firstAndOnlyOption = options.first, options.count == 1 else {
				
				fatalError("Cannot uniqely identify payment option.")
			}
			
			return firstAndOnlyOption
		}
        
        internal override func paymentOption(for type: PaymentType) -> PaymentOption
        {
            let options = self.paymentOptions.filter { $0.paymentType == .apple }
            guard let firstAndOnlyOption = options.first, options.count == 1 else {
                
                fatalError("Cannot uniqely identify payment option.")
            }
            
            return firstAndOnlyOption
        }
		
		internal override func currencySymbol(for currency: Currency) -> String {
			
			if let amountedCurrency = self.supportedCurrencies.first(where: { $0.currency == currency }) {
				
				return amountedCurrency.currencySymbol
			}
			else {
				
				return CurrencyFormatter.shared.localizedCurrencySymbol(for: currency.isoCode)
			}
		}
		
		internal override func iconURL(for cardBrand: CardBrand, scheme: CardScheme?) -> URL? {
			
			let brand = self.appliedCardBrand(from: cardBrand, scheme: scheme)
			
			let possibleOptions = self.paymentOptions.filter { $0.brand == brand || $0.supportedCardBrands.contains(brand) }
			if let original = possibleOptions.first(where: { $0.brand == brand }) {
				
				return original.imageURL
			}
			else {
				
				return possibleOptions.first?.imageURL
			}
		}
		
		internal override func didReceive(_ token: Token, from request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			let source = SourceRequest(token: token)
			let retryAction: TypeAlias.ArgumentlessClosure = {
				
				self.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
			}
			
			self.callChargeOrAuthorizeAPI(with:                           	source,
										  paymentOption:                   	paymentOption,
										  token:							token,
										  cardBIN:                         	token.card.binNumber,
										  saveCard:                        	saveCard,
										  loader:                          	nil,
										  retryAction:                     	retryAction,
										  alertDismissButtonClickHandler:  	nil)
		}
		
        internal override func callChargeApplePayAPI(for session: SessionProtocol) {
            session.delegate?.applePaymentSucceed?("You will get back the charge object back", on: session)
        }
        
        internal override func callChargeOrAuthorizeAPI(with source:					SourceRequest,
														paymentOption:					PaymentOption,
														token:							Token?,
														cardBIN:						String?,
														saveCard:						Bool?,
														loader:							LoadingViewSupport?,
														retryAction:					@escaping TypeAlias.ArgumentlessClosure,
														alertDismissButtonClickHandler:	TypeAlias.ArgumentlessClosure?) {
			
			guard
				
				let dataSource	= self.process.process.externalSession?.dataSource,
				let customer	= dataSource.customer,
				let orderID     = self.orderIdentifier else {
					
					fatalError("This case should never happen.")
			}
			
			self.isExecutingAPICalls = true
			
			var post: TrackingURL? = nil
			if let postURL = dataSource.postURL, let nonnullPostURL = postURL {
				
				post = TrackingURL(url: nonnullPostURL)
			}
			// the Amounted Currency assigned by the merchant
            var totalAmount:Decimal = dataSource.amount  ?? 0
            if totalAmount == 0
            {
                totalAmount = transactionCurrency.amount
            }
            let amountedCurrency    =  AmountedCurrency(dataSource.currency!!, totalAmount)
			// the Amounted Currency selected by the user
			let amountedSelectedCurrency = self.selectedCurrency

			let fee                 = Process.AmountCalculator<PaymentClass>.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
			let destinations			= dataSource.destinations ?? nil
			/// the API is using destinationsGroup not destinations
			let destinationsGroup	= (destinations?.count ?? 0 > 0) ? DestinationGroup(destinations: destinations)!: nil


			let order               	= Order(identifier: orderID)
			let redirect            	= TrackingURL(url: self.process.webPaymentHandlerInterface.returnURL)
			let paymentDescription  	= dataSource.paymentDescription ?? nil
			let paymentMetadata     	= dataSource.paymentMetadata ?? nil
			let reference           	= dataSource.paymentReference ?? nil
            let topup                   = dataSource.topup ?? nil
            
            topup?.amount = totalAmount
            topup?.currency = dataSource.currency ?? nil
            
			var shouldSaveCard      	= saveCard ?? false
			let statementDescriptor 	= dataSource.paymentStatementDescriptor ?? nil
            var requires3DSecure    	= (self.requires3DSecure || (dataSource.require3DSecure ?? false))
            switch paymentOption.threeDLevel {
            case .always:
                requires3DSecure = true
                break
            case .never:
                requires3DSecure = false
                break
            default:
                break
            }
			let receiptSettings     	= dataSource.receiptSettings ?? nil
			let merchantID			= dataSource.merchantID ?? nil
			
			var merchant: Merchant? = nil
			if let nonnullMerchantID = merchantID {
				
				merchant = Merchant(identifier: nonnullMerchantID)
			}
			
			var canSaveCard: Bool
			if let nonnullToken = token, self.shouldSaveCard(with: nonnullToken) {
				
				canSaveCard = true
			}
			else {
				
				canSaveCard = false
			}
			
			if !canSaveCard {
				
				shouldSaveCard = false
			}
			
			let mode = dataSource.mode ?? .default
			
			switch mode {
				
			case .purchase:
				
				let chargeRequest = CreateChargeRequest(amount:                 amountedCurrency.amount,
														selectedAmount:			amountedSelectedCurrency.amount,
														currency:               amountedCurrency.currency,
														selectedCurrency:     	amountedSelectedCurrency.currency,
														customer:               customer,
														merchant:				merchant,
														fee:                    fee,
														order:                  order,
														redirect:               redirect,
														post:                   post,
														source:                 source,
														destinationGroup:		destinationsGroup,
														descriptionText:        paymentDescription,
														metadata:               paymentMetadata,
														reference:              reference,
														shouldSaveCard:         shouldSaveCard,
														statementDescriptor:    statementDescriptor,
														requires3DSecure:       requires3DSecure,
														receipt:                receiptSettings,
                                                        topup:                  topup)
				
				APIClient.shared.createCharge(with: chargeRequest) { [weak self] (charge, error) in
					
					loader?.hideLoader()
					self?.process.buttonHandlerInterface.stopButtonLoader()
					self?.isExecutingAPICalls = false
					
					self?.handleChargeOrAuthorizeResponse(charge,
														  error:							error,
														  paymentOption:					paymentOption,
														  cardBIN:							cardBIN,
														  retryAction:						retryAction,
														  alertDismissButtonClickHandler:	alertDismissButtonClickHandler)
				}
				
			case .authorizeCapture:
				
				let authorizeAction = dataSource.authorizeAction ?? .default
				
				let authorizeRequest = CreateAuthorizeRequest(
															  amount:               amountedCurrency.amount,
															  selectedAmount:		amountedSelectedCurrency.amount,
															  currency:             amountedCurrency.currency,
															  selectedCurrency:     amountedSelectedCurrency.currency,
															  customer:				customer,
															  merchant:				merchant,
															  fee:					fee,
															  order:				order,
															  redirect:				redirect,
															  post:					post,
															  source:				source,
															  destinationGroup:		destinationsGroup,
															  descriptionText:		paymentDescription,
															  metadata:				paymentMetadata,
															  reference:			reference,
															  shouldSaveCard:		shouldSaveCard,
															  statementDescriptor:	statementDescriptor,
															  requires3DSecure:		requires3DSecure,
															  receipt:				receiptSettings,
															  authorizeAction:		authorizeAction)
				
				APIClient.shared.createAuthorize(with: authorizeRequest) { [weak self] (authorize, error) in
					
					loader?.hideLoader()
					self?.process.buttonHandlerInterface.stopButtonLoader()
					self?.isExecutingAPICalls = false
					
					self?.handleChargeOrAuthorizeResponse(authorize,
														  error:							error,
														  paymentOption:					paymentOption,
														  cardBIN:							cardBIN,
														  retryAction:						retryAction,
														  alertDismissButtonClickHandler:	alertDismissButtonClickHandler)
				}
				
			case .cardSaving:
				
				fatalError("Internal SDK error. Attempt to charge in card saving mode.")
				
			case .cardTokenization:
				
				fatalError("Internal SDK error. Attempt to charge in card tokenization mode.")
			}
		}
		
		internal override func handleChargeOrAuthorizeResponse<T>(_ chargeOrAuthorize: T?, error: TapSDKError?, retryAction: @escaping TypeAlias.ArgumentlessClosure) where T: ChargeProtocol {
			
			guard let paymentOption = self.currentPaymentOption else { return }
			
			self.handleChargeOrAuthorizeResponse(chargeOrAuthorize, error: error, paymentOption: paymentOption, cardBIN: self.currentPaymentCardBINNumber, retryAction: retryAction, alertDismissButtonClickHandler: nil)
		}
		
		internal override func updateUIByRemoving(_ card: SavedCard) {
			
			guard let cardIndex = self.paymentOptionsResponse?.savedCards?.firstIndex(of: card) else { return }
			self.paymentOptionsResponse?.savedCards?.remove(at: cardIndex)
			
			let remainingNumberOfCards = self.paymentOptionsResponse?.savedCards?.count ?? 0
			if remainingNumberOfCards == 0 {
				
				self.isInDeleteSavedCardsMode = false
				self.process.viewModelsHandlerInterface.updateViewModels()
			}
			else {
				
				self.process.viewModelsHandlerInterface.cardsContainerCellModel.updateData(with: self.recentCards)
			}
		}
		
		internal override func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize:				T?,
																				  error:							TapSDKError?,
																				  paymentOption:					PaymentOption,
																				  cardBIN:							String?,
																				  retryAction:						@escaping TypeAlias.ArgumentlessClosure,
																				  alertDismissButtonClickHandler:	TypeAlias.ArgumentlessClosure?) {
			
			if let nonnullError = error {
				
				ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
				return
			}
			
			guard let nonnullChargeOrAuthorize = chargeOrAuthorize else { return }
			
			self.currentChargeOrAuthorize = nonnullChargeOrAuthorize
			
			switch nonnullChargeOrAuthorize.status {
				
			case .initiated:
				
				if let authentication = nonnullChargeOrAuthorize.authentication, authentication.status == .initiated {
					
					switch authentication.type {
						
					case .biometrics:
						
						break
						
					case .otp:
						
						self.process.openOTPScreen(with: authentication.value, for: paymentOption)
					}
				}
				else if let url = nonnullChargeOrAuthorize.transactionDetails.url {
					
					self.process.openPaymentURL(url, for: paymentOption, binNumber: cardBIN)
				}
            case .inProgress:
                
                self.process.showAsyncPaymentResult(nonnullChargeOrAuthorize, for: paymentOption)
                
			case .abandoned, .cancelled, .failed, .declined, .restricted, .unknown, .void:
				
				self.process.paymentFailure(with: nonnullChargeOrAuthorize.status, chargeOrAuthorize: nonnullChargeOrAuthorize, error: error)
				
			case .captured, .authorized:
				
				self.process.paymentSuccess(with: nonnullChargeOrAuthorize)
			}
		}
		
		internal override func paymentCancelled() {
			
			self.process.viewModelsHandlerInterface.deselectAllPaymentOptionsModels()
			
			self.currentPaymentOption               = nil
			self.currentPaymentCardBINNumber        = nil
			self.urlToLoadInWebPaymentController    = nil
			self.currentChargeOrAuthorize           = nil
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		
		
		// MARK: Methods
		
		private func appliedCardBrand(from brand: CardBrand, scheme: CardScheme?) -> CardBrand {
			
			if let schemeBrand = scheme?.cardBrand {
				
				let currency = self.selectedCurrency.currency
				let filterClosure: (PaymentOption) -> Bool = { $0.brand == schemeBrand && $0.supportedCurrencies.contains(currency) }
				
				if self.paymentOptions.first(where: filterClosure) != nil {
					
					return schemeBrand
				}
			}
			
			return brand
		}
	}
	
	final class CardSavingDataManager: DataManager {
		
		private var _currentPaymentOption: PaymentOption?
		
		internal override var currentPaymentOption: PaymentOption? {
			
			get {
				
				return self._currentPaymentOption ?? self.process.viewModelsHandlerInterface.cardPaymentOptionsCellModel.paymentOption
			}
			set {
				
				self._currentPaymentOption = newValue
			}
		}
		
		internal override var shouldToggleSaveCardSwitchToOnAutomatically: Bool {
			
			return false
		}
		
		internal override func createPaymentOptionsRequest(for session: SessionProtocol, callingIfFailed closure: (String, String) -> Void) -> PaymentOptionsRequest? {
			
			guard let nonnullDataSource = session.dataSource else {
				
				closure("Error", "Payment data source cannot be nil.")
				return nil
			}
			
			guard let customer = nonnullDataSource.customer else {
				
				closure("Error", "Customer information must be provided.")
				return nil
			}
			
			let paymentRequest = PaymentOptionsRequest(customer: customer.identifier)
			
			return paymentRequest
		}
		
		internal override func didReceive(_ token: Token, from request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			if !self.shouldSaveCard(with: token) {
				
				let userInfo = [NSLocalizedFailureReasonErrorKey: "Same card already exists."]
				let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.cardAlreadyExists.rawValue, userInfo: userInfo)
				let sdkError = TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
				
				ErrorDataManager.handle(sdkError, retryAction: nil, alertDismissButtonClickHandler: nil)
				
				self.process.buttonHandlerInterface.stopButtonLoader()
				
				return
			}
			
			let retryAction: TypeAlias.ArgumentlessClosure = {
				
				self.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
			}
			
			self.callCardVerificationAPI(with: token, saveCard: saveCard, retryAction: retryAction)
		}
		
		private func callCardVerificationAPI(with token: Token, saveCard: Bool?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			
			guard let dataSource = self.process.process.externalSession?.dataSource, let customer = dataSource.customer else {
				
				fatalError("This case should never happen.")
			}
			
			self.isExecutingAPICalls = true
			
			let requires3DSecure    = self.requires3DSecure || (dataSource.require3DSecure ?? false)
			let shouldSaveCard      = saveCard ?? false
			let metadata			= dataSource.paymentMetadata ?? nil
			let source				= SourceRequest(token: token)
			let redirect            = TrackingURL(url: self.process.webPaymentHandlerInterface.returnURL)
			let currency			= self.selectedCurrency.currency
			
			let verificationRequest = CreateCardVerificationRequest(is3DSecureRequired:	requires3DSecure,
																	shouldSaveCard:		shouldSaveCard,
																	metadata:			metadata,
																	customer:			customer,
																	currency:			currency,
																	source:				source,
																	redirect:			redirect)
			
			APIClient.shared.createCardVerification(with: verificationRequest) { [weak self] (response, error) in
				
				self?.process.buttonHandlerInterface.stopButtonLoader()
				self?.isExecutingAPICalls = false
				
				self?.handleCardVerificationResponse(response, error: error, binNumber: token.card.binNumber, retryAction: retryAction)
			}
		}
		
		internal override func handleCardVerificationResponse(_ cardVerification: CardVerification?, error: TapSDKError?, binNumber: String?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			
			guard let paymentOption = self.currentPaymentOption else { return }
			
			if let nonnullError = error {
				
				ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: nil)
				return
			}
			
			guard let nonnullVerification = cardVerification else { return }
			
			self.currentVerification = cardVerification
			
			switch nonnullVerification.status {
				
			case .initiated:
				
				if let url = nonnullVerification.transactionDetails.url {
					
					self.process.openPaymentURL(url, for: paymentOption, binNumber: binNumber)
				}
				
			case .invalid:
				
				self.process.cardSavingFailure(with: nonnullVerification, error: error)
				
			case .valid:
				
				self.process.cardSavingSuccess(with: nonnullVerification)
			}
		}
	}
	
	final class CardTokenizationDataManager: DataManager {
        
        internal override func createPaymentOptionsRequest(for session: SessionProtocol, callingIfFailed closure: (String, String) -> Void) -> PaymentOptionsRequest? {
			
			guard let nonnullDataSource = session.dataSource else {
				
				closure("Error", "Payment data source cannot be nil.")
				return nil
			}
			
			guard let currency = nonnullDataSource.currency else {
				
				closure("Error", "Currency must be provided.")
				return nil
			}
			
			guard let customer = nonnullDataSource.customer else {
				
				closure("Error", "Customer information must be provided.")
				return nil
			}
			
			let itemsCount = (nonnullDataSource.items ?? [])?.count ?? 0
			guard nonnullDataSource.amount != nil || itemsCount > 0 else {
				
				closure("Error", "Either amount or items should be implemented in payment data source. If items is implemented, number of items should be > 0.")
				return nil
			}
			
			let transactionMode	= nonnullDataSource.mode        ?? .default
			let merchantID		= nonnullDataSource.merchantID	?? nil
			
			let shipping        = nonnullDataSource.shipping    ?? nil
			let taxes           = nonnullDataSource.taxes       ?? nil
			let destinations		= nonnullDataSource.destinations       ?? nil
			/// the API is using destinationsGroup not destinations
			let destinationsGroup = DestinationGroup(destinations: destinations)
			let paymentType		= nonnullDataSource.paymentType       ?? nil
            let topup        = nonnullDataSource.topup       ?? nil

			let paymentRequest = PaymentOptionsRequest(transactionMode: transactionMode,
													   amount:          nonnullDataSource.amount,
													   items:           nonnullDataSource.items ?? [],
													   shipping:        shipping,
													   taxes:           taxes,
													   currency:        currency,
													   merchantID:		merchantID,
													   customer:        customer.identifier,
													   destinationGroup:	destinationsGroup,
													   paymentType:			paymentType,
                                                       topup: topup)
			
			return paymentRequest
		}
		
		internal override var shouldToggleSaveCardSwitchToOnAutomatically: Bool {
			
			return (self.process.process.externalSession?.dataSource?.isSaveCardSwitchOnByDefault ?? true) && !self.didToggleSaveCardSwitchToOnAutomatically
		}
        
		
		internal override func didReceive(_ token: Token, from request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			self.process.cardTokenizationSuccess(with: token, customerRequestedToSaveCard: saveCard ?? false)
		}
	}
}
