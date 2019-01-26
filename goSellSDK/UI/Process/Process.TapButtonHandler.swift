//
//  PaymentProcess.TapButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

private var tap_processTapButtonHandlerAmountKey: UInt8 = 0
private var tap_processTapButtonHandlerProcessKey: UInt8 = 0

internal protocol TapButtonHandlerInterface {
	
	func setButton(_ button: TapButton?)
	func updateButtonState()
	
	func startButtonLoader()
	func stopButtonLoader()
}

internal extension Process {
	
	internal class TapButtonHandler<Mode: ProcessMode>: TapButtonHandlerInterface, TapButtonDelegate, LocalizationObserver {
	
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
				
				self.button?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == style })!
			}
		}
		
		internal var clickCallback: TypeAlias.ArgumentlessClosure?
		
		internal var canBeHighlighted: Bool {
			
			return true
		}
		
		// MARK: Methods
		
		internal init() {
			
			self.startMonitoringLocalizationChanges()
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
		}
		
		internal final func startButtonLoader() {
			
			self.button?.startLoader()
		}
		
		internal final func stopButtonLoader() {
			
			self.button?.stopLoader()
		}
		
		internal func updateButtonState() {
			
			if let payProcessHandler = self as? TapButtonProcessHandler<PaymentClass, Implementation<PaymentClass>> {
				
				payProcessHandler.updatePayProcessButtonState()
			}
			else if let saveProcessHandler = self as? TapButtonProcessHandler<CardSavingClass, Implementation<CardSavingClass>> {
				
				saveProcessHandler.updateSaveProcessButtonState()
			}
			else if let payHandler = self as? TapButtonHandler<PaymentClass> {
				
				payHandler.updatePayButtonState()
			}
			else if let saveHandler = self as? TapButtonHandler<CardSavingClass> {
				
				saveHandler.updateSaveButtonState()
			}
		}
		
		internal func buttonTouchUpInside() {
			
			self.buttonClicked()
		}
		
		internal func securityButtonTouchUpInside() {
			
			self.buttonClicked()
		}
		
		internal func localizationChanged() {
			
			self.updateButtonState()
		}
		
		deinit {
			
			self.stopMonitoringLocalizationChanges()
			self.clickCallback = nil
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private var _amount: AmountedCurrency?
	}
}

internal extension Process.TapButtonHandler where Mode: Payment {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var amount: AmountedCurrency? {
		
		get {
			
			return self._amount
		}
		set {
			
			self._amount = newValue
			
			self.updateAmountOnTheButton()
		}
	}
	
	// MARK: Methods
	
	internal func updatePayButtonState() {
		
		self.updateAmountOnTheButton()
	}
	
	private func updateAmountOnTheButton() {
		
		guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
			
			self.button?.setLocalizedText(.btn_pay_title_generic)
			self.button?.forceDisabled = true
			
			return
		}
		
		let amountString = CurrencyFormatter.shared.format(displayedAmount)
		self.button?.setLocalizedText(.btn_pay_title_amount, amountString)
		
		self.button?.forceDisabled = false
	}
}

internal extension Process.TapButtonHandler where Mode: CardSaving {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func updateSaveButtonState() {
		
		self.button?.setLocalizedText(.btn_save_title)
		self.button?.forceDisabled = false
	}
}

internal extension Process {
	
	internal final class TapButtonProcessHandler<Mode, ProcessClass>: TapButtonHandler<Mode>, ProcessHandlerInterface where ProcessClass: ProcessGenericInterface, ProcessClass.HandlerMode == Mode {
		
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
	}
}

internal extension Process.TapButtonProcessHandler where Mode: Payment {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func updatePayProcessButtonState() {
		
		self.updateAmount()
		self.buttonStyle = .pay
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel else {
			
			self.makeButtonEnabled(false)
			return
		}
		
		let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
		self.makeButtonEnabled(payButtonEnabled)
	}
	
	internal func payProcessButtonClicked() {
		
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

	internal func saveProcessButtonClicked() {
	
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.process.dataManagerInterface.isExecutingAPICalls else { return }
		
		self.process.startPayment(with: selectedPaymentViewModel)
	}
	
	internal func updateSaveProcessButtonState() {
		
		self.buttonStyle = .draewilSave
		self.button?.setLocalizedText(.btn_save_action_title)
		
		guard let selectedPaymentViewModel = self.process.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel else {
			
			self.makeButtonEnabled(false)
			return
		}
		
		let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
		self.makeButtonEnabled(payButtonEnabled)
	}
}
