//
//  LocalizationObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol LocalizationObserver: ClassProtocol {
	
	func localizationChanged()
}

internal extension LocalizationObserver {
	
	internal func startMonitoringLocalizationChanges() {
		
		NotificationCenter.default.addObserver(forName: .sdkLanguageChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.localizationChanged()
		}
	}
	
	internal func stopMonitoringLocalizationChanges() {
		
		NotificationCenter.default.removeObserver(self, name: .sdkLanguageChanged, object: nil)
	}
}
