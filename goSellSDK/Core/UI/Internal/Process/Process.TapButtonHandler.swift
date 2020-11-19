//
//  PaymentProcess.TapButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias

private var tap_processTapButtonHandlerAmountKey: UInt8 = 0
private var tap_processTapButtonHandlerProcessKey: UInt8 = 0

internal protocol TapButtonHandlerInterface {
	
	func setButton(_ button: TapButton?)
	func updateButtonState()
	
	func startButtonLoader()
	func stopButtonLoader()
}

internal extension Process {
	
	class TapButtonHandler<Mode: ProcessMode>: TapButtonHandlerInterface, TapButton.Delegate, LocalizationObserver {
	
		// MARK: - Internal -
		// MARK: Properties
		
		internal private(set) weak var button: TapButton? {
			
			didSet {
				
				self.button?.delegate = self
			}
		}
		
		internal var buttonStyle: TapButtonStyle.ButtonType? {
			
			didSet {
				
				guard let style = self.buttonStyle else { return }
				
				self.updateWithButtonStyle(style)
			}
		}
		
		internal var clickCallback: TypeAlias.ArgumentlessClosure?
		
		internal var canBeHighlighted: Bool {
			
			return true
		}
		
		// MARK: Methods
		
		internal init() {
			
			self.localizationObservation = self.startMonitoringLocalizationChanges()
		}
		
		internal func setButton(_ button: TapButton?) {
			
			self.button = button
			self.updateButtonState()
		}
		
		internal func makeButtonEnabled(_ enabled: Bool) {
			
			self.button?.isEnabled = enabled
		}
		
		internal func buttonClicked() {
			
			self.clickCallback?()
			
			if let payProcessHandler = self as? TapButtonProcessHandler<PaymentClass, Implementation<PaymentClass>> {
				
				payProcessHandler.payProcessButtonClicked()
			}
			if let saveProcessHandler = self as? TapButtonProcessHandler<CardSavingClass, Implementation<CardSavingClass>> {
				
				saveProcessHandler.saveProcessButtonClicked()
			}
			if let tokenizeProcessHandler = self as? TapButtonProcessHandler<CardTokenizationClass, Implementation<CardTokenizationClass>> {
				
				tokenizeProcessHandler.tokenizeProcessButtonClicked()
			}
		}
		
		internal func disabledButtonClicked() {
			
			guard Process.hasAliveInstance else { return }
			guard let errorCode = Process.shared.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel?.errorCode else { return }
			
			ErrorDataManager.handle(errorCode)
		}
		
		internal func startButtonLoader() {
			
			self.button?.startLoader()
		}
		
		internal func stopButtonLoader() {
			
			self.button?.stopLoader()
		}
		
		internal func updateButtonState() {
            if self.button?.themeStyle.type == .async
            {
                return
            }
			if let payProcessHandler = self as? TapButtonProcessHandler<PaymentClass, Implementation<PaymentClass>> {
				
				payProcessHandler.updatePayProcessButtonState()
			}
			else if let saveProcessHandler = self as? TapButtonProcessHandler<CardSavingClass, Implementation<CardSavingClass>> {
				
				saveProcessHandler.updateSaveProcessButtonState()
			}
			else if let tokenizeProcessHandler = self as? TapButtonProcessHandler<CardTokenizationClass, Implementation<CardTokenizationClass>> {
				
				tokenizeProcessHandler.updateTokenizeProcessButtonState()
			}
			else if let payHandler = self as? TapButtonHandler<PaymentClass> {
				
				payHandler.updatePayButtonState()
			}
			else if let saveHandler = self as? TapButtonHandler<CardSavingClass> {
				
				saveHandler.updateSaveButtonState()
			}
			else if let tokenizeHandler = self as? TapButtonHandler<CardTokenizationClass> {
				
				tokenizeHandler.updateTokenizeButtonState()
			}
		}
		
		internal func buttonTouchUpInside() {
			
			self.buttonClicked()
		}
		
		internal func securityButtonTouchUpInside() {
			
			self.buttonClicked()
		}
		
		internal func disabledButtonTouchUpInside() {
			
			self.disabledButtonClicked()
		}
		
		internal func localizationChanged() {
			
			self.updateButtonState()
		}
		
		deinit {
			
			self.stopMonitoringLocalizationChanges(self.localizationObservation)
			self.localizationObservation = nil
			
			self.clickCallback = nil
		}
		
		// MARK: - Fileprivate -
		// MARK: Methods
		
		fileprivate func updateWithButtonStyle(_ style: TapButtonStyle.ButtonType) {
			
			self.button?.themeStyle = ThemeManager.shared.originalCurrentTheme.buttonStyles.first(where: { $0.type == style })!
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private var _amount: AmountedCurrency?
		
		private var localizationObservation: NSObjectProtocol?
	}
}

internal extension Process.TapButtonHandler where Mode: Payment {
	
	// MARK: - Internal -
	// MARK: Properties
	
	var amount: AmountedCurrency? {
		
		get {
			
			return self._amount
		}
		set {
			
			self._amount = newValue
			
			self.updateAmountOnTheButton()
		}
	}
	
	// MARK: Methods
	
	func updatePayButtonState() {
		
		self.updateAmountOnTheButton()
	}
	
	 func updateAmountOnTheButton() {
		
		guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
			
            
            if let payString = Process.shared.externalSession?.dataSource?.buttonTitle {
                self.button?.setTitle(payString)
            }else{
                self.button?.setLocalizedText(.btn_pay_title_generic)
            }
			
			self.button?.forceDisabled = true
			
			return
		}
		
		let amountString = CurrencyFormatter.shared.format(displayedAmount)
        if let payString = Process.shared.externalSession?.dataSource?.buttonTitle {
            if Process.shared.externalSession?.dataSource?.showAmountOnPayButton ?? true {
                self.button?.setTitle(String(format: "\(payString!) %@", amountString))
            }else{
                self.button?.setTitle(payString)
            }
        }else{
            self.button?.setLocalizedText(.btn_pay_title_amount, amountString)
        }
		
		
		self.button?.forceDisabled = false
	}
}

internal extension Process.TapButtonHandler where Mode: CardSaving {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func updateSaveButtonState() {
		
        if let saveString = Process.shared.externalSession?.dataSource?.buttonTitle {
            self.button?.setTitle(saveString)
        }else{
            self.button?.setLocalizedText(.btn_save_title)
        }
		self.button?.forceDisabled = false
	}
}

internal extension Process.TapButtonHandler where Mode: CardTokenization {
	
	// MARK: - Internal -
	// MARK: Properties
	
	var amount: AmountedCurrency? {
		
		get {
			
			return self._amount
		}
		set {
			
			self._amount = newValue
			
			self.updateAmountOnTheButton()
		}
	}
	
	// MARK: Methods
	
	func updateTokenizeButtonState() {
		
		self.updateAmountOnTheButton()
	}
	
	private func updateAmountOnTheButton() {
		
		guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
			
            if let payString = Process.shared.externalSession?.dataSource?.buttonTitle {
                self.button?.setTitle(payString)
            }else{
                self.button?.setLocalizedText(.btn_pay_title_generic)
            }
			self.button?.forceDisabled = true
			
			return
		}
		
		let amountString = CurrencyFormatter.shared.format(displayedAmount)
        if let payString = Process.shared.externalSession?.dataSource?.buttonTitle {
            if Process.shared.externalSession?.dataSource?.showAmountOnPayButton ?? true {
                self.button?.setTitle(String(format: "\(payString!) %@", amountString))
            }else{
                self.button?.setTitle(payString)
            }
        }else{
            self.button?.setLocalizedText(.btn_pay_title_amount, amountString)
        }
		
		self.button?.forceDisabled = false
	}
}

internal extension Process {
	
	final class TapButtonProcessHandler<Mode, ProcessClass>: TapButtonHandler<Mode>, ProcessHandlerInterface where ProcessClass: ProcessGenericInterface, ProcessClass.HandlerMode == Mode {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessClass
		
		internal override var canBeHighlighted: Bool {
			
			return !self.process.dataManagerInterface.isExecutingAPICalls
		}
		
		// MARK: Methods
		
		internal init(process: ProcessClass) {
			
			self.process = process
			super.init()
		}
		
		internal convenience init(process: ProcessClass, button: TapButton?) {
			
			self.init(process: process)
			self.setButton(button)
		}
		
		internal override func startButtonLoader() {
			
			guard let button = self.button else { return }
			let enabled = button.isEnabled && !button.forceDisabled
			
			let settings = button.themeStyle
			let stateSettings = enabled ? (button.isHighlighted ? settings.highlighted : settings.enabled) : settings.disabled
			if stateSettings.isLoaderVisible {
				
				super.startButtonLoader()
			}
			else {
				
				guard let paymentContentController = PaymentContentViewController.tap_findInHierarchy() else { return }
				LoadingView.show(in: paymentContentController, animated: true)
			}
		}
		
		internal override func stopButtonLoader() {
			
			guard let button = self.button else { return }
			let enabled = button.isEnabled && !button.forceDisabled
			
			let settings = button.themeStyle
			let stateSettings = enabled ? (button.isHighlighted ? settings.highlighted : settings.enabled) : settings.disabled
			if stateSettings.isLoaderVisible {
				
				super.stopButtonLoader()
			}
			else {
				
				guard let paymentContentController = PaymentContentViewController.tap_findInHierarchy() else { return }
				paymentContentController.hideLoader()
			}
		}
		
		// MARK: - Fileprivate
		// MARK: Methods
		
		fileprivate override func updateWithButtonStyle(_ style: TapButtonStyle.ButtonType) {
			
			self.button?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == style })!
		}
	}
}

internal extension Process.TapButtonProcessHandler where Mode: Payment {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func updatePayProcessButtonState() {
		
		self.updateAmount()
		self.buttonStyle = .pay
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel else {
			
			self.makeButtonEnabled(false)
			return
		}
		
		let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
		self.makeButtonEnabled(payButtonEnabled)
	}
	
	func payProcessButtonClicked() {
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.process.dataManagerInterface.isExecutingAPICalls else { return }
		
		self.process.startPayment(with: selectedPaymentViewModel)
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	private func updateAmount() {
		
		let amountedCurrency = self.process.dataManagerInterface.selectedCurrency
		
		if let paymentOption = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel?.paymentOption {
			
			let extraFeeAmount = Process.AmountCalculator<PaymentClass>.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
			
			let amount = AmountedCurrency(amountedCurrency.currency,
										  amountedCurrency.amount + extraFeeAmount,
										  amountedCurrency.currencySymbol)
			
			self.amount = amount
		}
		else {
			
			self.amount = amountedCurrency
		}
	}
}

internal extension Process.TapButtonProcessHandler where Mode: CardSaving {

	func saveProcessButtonClicked() {
	
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.process.dataManagerInterface.isExecutingAPICalls else { return }
		
		self.process.startPayment(with: selectedPaymentViewModel)
	}
	
	func updateSaveProcessButtonState() {
		
		self.buttonStyle = .save
        if let saveString = Process.shared.externalSession?.dataSource?.buttonTitle {
            self.button?.setTitle(saveString)
        }else{
            self.button?.setLocalizedText(.btn_save_action_title)
        }
		
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel else {
			
			self.makeButtonEnabled(false)
			return
		}
		
		let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
		self.makeButtonEnabled(payButtonEnabled)
	}
}

internal extension Process.TapButtonProcessHandler where Mode: CardTokenization {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func tokenizeProcessButtonClicked() {
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.process.dataManagerInterface.isExecutingAPICalls else { return }
		
		self.process.startPayment(with: selectedPaymentViewModel)
	}
	
	func updateTokenizeProcessButtonState() {
		
		self.updateAmount()
		self.buttonStyle = .pay
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel else {
			
			self.makeButtonEnabled(false)
			return
		}
		
		let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
		self.makeButtonEnabled(payButtonEnabled)
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	private func updateAmount() {
		
		let amountedCurrency = self.process.dataManagerInterface.selectedCurrency
		
		if let paymentOption = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel?.paymentOption {
			
			let extraFeeAmount = Process.AmountCalculator<CardTokenizationClass>.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
			
			let amount = AmountedCurrency(amountedCurrency.currency,
										  amountedCurrency.amount + extraFeeAmount,
										  amountedCurrency.currencySymbol)
			
			self.amount = amount
		}
		else {
			
			self.amount = amountedCurrency
		}
	}
}
