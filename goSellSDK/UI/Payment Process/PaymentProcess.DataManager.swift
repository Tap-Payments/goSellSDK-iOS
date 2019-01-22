//
//  PaymentProcess.DataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias
import enum		TapCardValidator.CardBrand
import class	UIKit.UIResponder.UIResponder

internal extension PaymentProcess {
	
	internal final class DataManager: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal var transactionMode: TransactionMode = .default
		
		internal var supportedCurrencies: [AmountedCurrency] {
			
			return self.paymentOptionsResponse?.supportedCurrenciesAmounts ?? []
		}
		
		internal var selectedCurrency: AmountedCurrency {
			
			return self.userSelectedCurrency ?? self.transactionCurrency
		}
		
		internal var userSelectedCurrency: AmountedCurrency? {
			
			didSet {
				
				self.process.viewModelsHandler.currencyChanged()
				self.process.buttonHandler.updateButtonState()
			}
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
		
		internal var paymentOptions: [PaymentOption] {
			
			return self.paymentOptionsResponse?.paymentOptions ?? []
		}
		
		internal var recentCards: [SavedCard] {
			
			return self.paymentOptionsResponse?.savedCards ?? []
		}
		
		internal var orderIdentifier: String? {
			
			return self.paymentOptionsResponse?.orderIdentifier
		}
		
		internal var isInDeleteSavedCardsMode: Bool = false {
			
			didSet {
				
				guard self.isInDeleteSavedCardsMode != oldValue else { return }
				
				if self.isInDeleteSavedCardsMode {
					
					self.process.viewModelsHandler.deselectAllPaymentOptionsModels()
				}
				
				self.process.viewModelsHandler.isInDeleteSavedCardsModeStateChanged()
			}
		}
		
		internal var isCallingPaymentAPI: Bool {
			
			let activeRoutes = Set(APIClient.shared.activeRequests.compactMap { Route(rawValue: $0.path) })
			let paymentAPIRoutes: Set<Route> = Set([.charges, .authorize, .token, .tokens])
			
			return activeRoutes.intersection(paymentAPIRoutes).count > 0
		}
		
		internal var isChargeOrAuthorizeInProgress: Bool {
			
			guard let chargeOrAuthorize = self.currentChargeOrAuthorize else { return false }
			
			switch chargeOrAuthorize.status {
				
			case .initiated, .inProgress: return true
			default: return false
				
			}
		}
		
		internal var currentChargeOrAuthorize: ChargeProtocol?
		internal var currentPaymentOption: PaymentOption?
		internal var currentPaymentCardBINNumber: String?
		internal var urlToLoadInWebPaymentController: URL?
		
		internal var appearance: AppearanceMode = .fullscreen
		
		internal private(set) var isLoadingPaymentOptions = false
		internal private(set) var isExecutingAPICalls = false
		
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func loadPaymentOptions(for session: SessionProtocol) -> Bool {
			
			guard !self.isLoadingPaymentOptions else { return false }
			
			guard let nonnullDataSource = session.dataSource else {
				
				self.process.showMissingInformationAlert(with: "Error", message: "Payment data source cannot be nil.")
				return false
			}
			
			guard let currency = nonnullDataSource.currency else {
				
				self.process.showMissingInformationAlert(with: "Error", message: "Currency must be provided.")
				return false
			}
			
			guard let customer = nonnullDataSource.customer else {
				
				self.process.showMissingInformationAlert(with: "Error", message: "Customer information must be provided.")
				return false
			}
			
			let itemsCount = (nonnullDataSource.items ?? [])?.count ?? 0
			guard nonnullDataSource.amount != nil || itemsCount > 0 else {
				
				self.process.showMissingInformationAlert(with: "Error", message: "Either amount or items should be implemented in payment data source. If items is implemented, number of items should be > 0.")
				return false
			}
			
			let appearanceMode	= nonnullDataSource.appearance	?? .default
			let transactionMode	= nonnullDataSource.mode        ?? .default
			let shipping        = nonnullDataSource.shipping    ?? nil
			let taxes           = nonnullDataSource.taxes       ?? nil
			
			self.transactionMode = transactionMode
			self.appearance	= AppearanceMode(appearanceMode, transactionMode)
			
			let paymentRequest = PaymentOptionsRequest(transactionMode: transactionMode,
													   amount:          nonnullDataSource.amount,
													   items:           nonnullDataSource.items ?? [],
													   shipping:        shipping,
													   taxes:           taxes,
													   currency:        currency,
													   customer:        customer.identifier)
			
			self.isLoadingPaymentOptions = true
			
			session.delegate?.sessionIsStarting?(session)
			
			APIClient.shared.getPaymentOptions(with: paymentRequest) { [weak self, weak session] (response, error) in
				
				guard let strongSelf = self, let nonnullSession = session else { return }
				
				strongSelf.isLoadingPaymentOptions = false
				
				if let nonnullError = error {
					
					let retryAction: TypeAlias.ArgumentlessClosure = {
						
						strongSelf.process.start(nonnullSession)
					}
					
					strongSelf.paymentOptionsResponse = nil
					nonnullSession.delegate?.sessionHasFailedToStart?(nonnullSession)
					
					ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: nil)
				}
				else if let nonnullResponse = response {
					
					strongSelf.paymentOptionsResponse = nonnullResponse
					
					strongSelf.process.showPaymentController()
					
					nonnullSession.delegate?.sessionHasStarted?(nonnullSession)
				}
			}
			
			return true
		}
		
		internal func paymentOptions(of type: PaymentType) -> [PaymentOption] {
			
			return self.paymentOptions.filter { $0.paymentType == type }
		}
		
		internal func paymentOption(for savedCard: SavedCard) -> PaymentOption {
			
			let options = self.paymentOptions.filter { $0.identifier == savedCard.paymentOptionIdentifier }
			guard let firstAndOnlyOption = options.first, options.count == 1 else {
				
				fatalError("Cannot uniqely identify payment option.")
			}
			
			return firstAndOnlyOption
		}
		
		internal func currencySymbol(for currency: Currency) -> String {
			
			if let amountedCurrency = self.supportedCurrencies.first(where: { $0.currency == currency }) {
				
				return amountedCurrency.currencySymbol
			}
			else {
				
				return CurrencyFormatter.shared.localizedCurrencySymbol(for: currency.isoCode)
			}
		}
		
		internal func iconURL(for cardBrand: CardBrand, scheme: CardScheme?) -> URL? {
			
			let brand = self.appliedCardBrand(from: cardBrand, scheme: scheme)
			
			let possibleOptions = self.paymentOptions.filter { $0.brand == brand || $0.supportedCardBrands.contains(brand) }
			if let original = possibleOptions.first(where: { $0.brand == brand }) {
				
				return original.imageURL
			}
			else {
				
				return possibleOptions.first?.imageURL
			}
		}
		
		internal func callTokenAPI(with request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool?) {
			
			UIResponder.tap_current?.resignFirstResponder()
			
			self.isExecutingAPICalls = true
			self.process.buttonHandler.startButtonLoader()
			
			APIClient.shared.createToken(with: request) { [weak self] (token, error) in
				
				if let nonnullError = error {
					
					self?.process.buttonHandler.stopButtonLoader()
					self?.isExecutingAPICalls = false
					
					let retryAction: TypeAlias.ArgumentlessClosure = {
						
						self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
					}
					
					ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: nil)
				}
				else if let nonnullToken = token {
					
					let source = SourceRequest(token: nonnullToken)
					let retryAction: TypeAlias.ArgumentlessClosure = {
						
						self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
					}
					
					self?.callChargeOrAuthorizeAPI(with:                            source,
												   paymentOption:                   paymentOption,
												   cardBIN:                         nonnullToken.card.binNumber,
												   saveCard:                        saveCard,
												   loader:                          nil,
												   retryAction:                     retryAction,
												   alertDismissButtonClickHandler:  nil)
				}
				else {
					
					self?.process.buttonHandler.stopButtonLoader()
					self?.isExecutingAPICalls = false
				}
			}
		}
		
		internal func callChargeOrAuthorizeAPI(with source:						SourceRequest,
											   paymentOption:					PaymentOption,
											   cardBIN:							String?,
											   saveCard:						Bool?,
											   loader:							LoadingViewSupport?,
											   retryAction:						@escaping TypeAlias.ArgumentlessClosure,
											   alertDismissButtonClickHandler:	TypeAlias.ArgumentlessClosure?) {
			
			guard
				
				let dataSource	= self.process.externalSession?.dataSource,
				let customer	= dataSource.customer,
				let orderID     = self.orderIdentifier else {
					
					fatalError("This case should never happen.")
			}
			
			self.isExecutingAPICalls = true
			
			var post: TrackingURL? = nil
			if let postURL = dataSource.postURL, let nonnullPostURL = postURL {
				
				post = TrackingURL(url: nonnullPostURL)
			}
			
			let amountedCurrency    = self.selectedCurrency
			let fee                 = AmountCalculator.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
			let order               = Order(identifier: orderID)
			let redirect            = TrackingURL(url: self.process.webPaymentHandler.returnURL)
			let paymentDescription  = dataSource.paymentDescription ?? nil
			let paymentMetadata     = dataSource.paymentMetadata ?? nil
			let reference           = dataSource.paymentReference ?? nil
			let shouldSaveCard      = saveCard ?? false
			let statementDescriptor = dataSource.paymentStatementDescriptor ?? nil
			let requires3DSecure    = self.chargeRequires3DSecure || (dataSource.require3DSecure ?? false)
			let receiptSettings     = dataSource.receiptSettings ?? nil
			
			let mode = dataSource.mode ?? .default
			switch mode {
				
			case .purchase:
				
				let chargeRequest = CreateChargeRequest(amount:                 amountedCurrency.amount,
														currency:               amountedCurrency.currency,
														customer:               customer,
														fee:                    fee,
														order:                  order,
														redirect:               redirect,
														post:                   post,
														source:                 source,
														descriptionText:        paymentDescription,
														metadata:               paymentMetadata,
														reference:              reference,
														shouldSaveCard:         shouldSaveCard,
														statementDescriptor:    statementDescriptor,
														requires3DSecure:       requires3DSecure,
														receipt:                receiptSettings)
				
				APIClient.shared.createCharge(with: chargeRequest) { [weak self] (charge, error) in
					
					loader?.hideLoader()
					self?.process.buttonHandler.stopButtonLoader()
					self?.isExecutingAPICalls = false
					
					self?.handleChargeOrAuthorizeResponse(									charge,
														  error:							error,
														  paymentOption:					paymentOption,
														  cardBIN:							cardBIN,
														  retryAction:						retryAction,
														  alertDismissButtonClickHandler:	alertDismissButtonClickHandler)
				}
				
			case .authorizeCapture:
				
				let authorizeAction = dataSource.authorizeAction ?? .default
				
				let authorizeRequest = CreateAuthorizeRequest(amount:                 amountedCurrency.amount,
															  currency:               amountedCurrency.currency,
															  customer:               customer,
															  fee:                    fee,
															  order:                  order,
															  redirect:               redirect,
															  post:                   post,
															  source:                 source,
															  descriptionText:        paymentDescription,
															  metadata:               paymentMetadata,
															  reference:              reference,
															  shouldSaveCard:         shouldSaveCard,
															  statementDescriptor:    statementDescriptor,
															  requires3DSecure:       requires3DSecure,
															  receipt:                receiptSettings,
															  authorizeAction:        authorizeAction)
				
				APIClient.shared.createAuthorize(with: authorizeRequest) { [weak self] (authorize, error) in
					
					loader?.hideLoader()
					self?.process.buttonHandler.stopButtonLoader()
					self?.isExecutingAPICalls = false
					
					self?.handleChargeOrAuthorizeResponse(									authorize,
														  error:							error,
														  paymentOption:					paymentOption,
														  cardBIN:							cardBIN,
														  retryAction:						retryAction,
														  alertDismissButtonClickHandler:	alertDismissButtonClickHandler)
				}
				
			case .cardSaving:
				
				fatalError("Internal SDK error. Attempt to charge in card saving mode.")
			}
		}
		
		internal func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize: T?, error: TapSDKError?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			
			guard let paymentOption = self.currentPaymentOption else { return }
			
			self.handleChargeOrAuthorizeResponse(chargeOrAuthorize, error: error, paymentOption: paymentOption, cardBIN: self.currentPaymentCardBINNumber, retryAction: retryAction, alertDismissButtonClickHandler: nil)
		}
		
		internal func updateUIByRemoving(_ card: SavedCard) {
			
			guard let cardIndex = self.paymentOptionsResponse?.savedCards?.index(of: card) else { return }
			self.paymentOptionsResponse?.savedCards?.remove(at: cardIndex)
			
			let remainingNumberOfCards = self.paymentOptionsResponse?.savedCards?.count ?? 0
			if remainingNumberOfCards == 0 {
				
				self.isInDeleteSavedCardsMode = false
				self.process.viewModelsHandler.updateViewModels(with: self.paymentOptionsResponse)
			}
			else {
				
				self.process.viewModelsHandler.cardsContainerCellModel.updateData(with: self.recentCards)
			}
		}
		
		internal func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize:			T?,
																		 error:							TapSDKError?,
																		 paymentOption:					PaymentOption,
																		 cardBIN:						String?,
																		 retryAction:					@escaping TypeAlias.ArgumentlessClosure,
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
				
			case .inProgress, .abandoned, .cancelled, .failed, .declined, .restricted, .unknown, .void:
				
				self.process.paymentFailure(with: nonnullChargeOrAuthorize.status, chargeOrAuthorize: nonnullChargeOrAuthorize, error: error)
				
			case .captured, .authorized:
				
				self.process.paymentSuccess(with: nonnullChargeOrAuthorize)
			}
		}
		
		internal func paymentCancelled() {
			
			self.process.viewModelsHandler.deselectAllPaymentOptionsModels()
			
			self.currentPaymentOption               = nil
			self.currentPaymentCardBINNumber        = nil
			self.urlToLoadInWebPaymentController    = nil
			self.currentChargeOrAuthorize           = nil
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
		
		private var paymentOptionsResponse: PaymentOptionsResponse? {
			
			didSet {
				
				self.process.viewModelsHandler.updateViewModels(with: self.paymentOptionsResponse)
			}
		}
		
		private var chargeRequires3DSecure: Bool {
			
			if let permissions = SettingsDataManager.shared.settings?.permissions {
				
				return !permissions.contains(.non3DSecureTransactions)
			}
			else {
				
				return true
			}
		}
		
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
}
