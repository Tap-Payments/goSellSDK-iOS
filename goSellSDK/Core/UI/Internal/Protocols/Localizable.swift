//
//  Localizable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal enum SingleLocalizableElement { case `default` }

internal protocol Localizable {
	
	associatedtype LocalizableElement
	
	func setLocalized(text: String?, for element: LocalizableElement)
}

internal protocol SingleLocalizable: Localizable where LocalizableElement == SingleLocalizableElement {
	
	func setLocalized(text: String?)
}

internal extension SingleLocalizable {
	
	func setLocalized(text: String?, for element: SingleLocalizableElement) {
		
		self.setLocalized(text: text)
	}
}

internal extension Localizable {
	
	func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?) {
		
		guard let nonnullKey = key else {
			
			self.setLocalized(text: nil, for: element)
			return
		}
		
		let text = LocalizationManager.shared.localizedString(for: nonnullKey)
		self.setLocalized(text: text, for: element)
	}
	
	func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?, _ arguments: CVarArg...) {
		
		self.setLocalizedText(for: element, key: key, arguments: arguments)
	}
	
	func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?, arguments: [CVarArg]) {
		
		guard let nonnullKey = key else {
			
			self.setLocalized(text: nil, for: element)
			return
		}
		
		let text = String(format: LocalizationManager.shared.localizedString(for: nonnullKey), arguments: arguments)
		self.setLocalized(text: text, for: element)
	}
}

internal extension Localizable where LocalizableElement == SingleLocalizableElement {
	
	func setLocalizedText(_ key: LocalizationKey?) {
		
		self.setLocalizedText(for: .default, key: key)
	}
	
	func setLocalizedText(_ key: LocalizationKey?, _ arguments: CVarArg...) {
		
		self.setLocalizedText(for: .default, key: key, arguments: arguments)
	}
}
