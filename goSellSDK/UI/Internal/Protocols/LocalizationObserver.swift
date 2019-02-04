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
	
	internal func startMonitoringLocalizationChanges() -> NSObjectProtocol {
		
		return NotificationCenter.default.addObserver(forName: .tap_sdkLanguageChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.localizationChanged()
		}
	}
	
	internal func stopMonitoringLocalizationChanges(_ observation: Any?) {
		
		if let nonnullObservation = observation {
			
			NotificationCenter.default.removeObserver(nonnullObservation)
		}
	}
}
