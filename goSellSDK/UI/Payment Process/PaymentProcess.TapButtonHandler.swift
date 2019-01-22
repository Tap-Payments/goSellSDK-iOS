//
//  PaymentProcess.TapButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal extension PaymentProcess {
	
	internal typealias TapProcessButtonHandler = TapButtonHandler & ProcessHandlerInterface
	
	internal class TapButtonHandler {
		
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
		
		internal var canButtonBeHighlighted: Bool { return false }
		
		internal var clickCallback: TypeAlias.ArgumentlessClosure?
		
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
		
		internal func updateButtonState() {}
		
		internal func buttonClicked() {
			
			self.clickCallback?()
		}
		
		internal final func startButtonLoader() {
			
			self.button?.startLoader()
		}
		
		internal final func stopButtonLoader() {
			
			self.button?.stopLoader()
		}
		
		deinit {
			
			self.stopMonitoringLocalizationChanges()
			self.clickCallback = nil
		}
	}
}

// MARK: - TapButtonDelegate
extension PaymentProcess.TapButtonHandler: TapButtonDelegate {
	
	internal var canBeHighlighted: Bool {
		
		return self.canButtonBeHighlighted
	}
	
	internal func buttonTouchUpInside() {
		
		self.buttonClicked()
	}
	
	internal func securityButtonTouchUpInside() {
		
		self.buttonClicked()
	}
}

// MARK: - LocalizationObserver
extension PaymentProcess.TapButtonHandler: LocalizationObserver {
	
	internal func localizationChanged() {
		
		self.updateButtonState()
	}
}
