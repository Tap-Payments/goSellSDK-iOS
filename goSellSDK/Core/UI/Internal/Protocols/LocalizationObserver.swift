//
//  LocalizationObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol LocalizationObserver: ClassProtocol {
	
	func localizationChanged()
}

internal extension LocalizationObserver {
	
	func startMonitoringLocalizationChanges() -> NSObjectProtocol {
		
		return NotificationCenter.default.addObserver(forName: .tap_sdkLanguageChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.localizationChanged()
		}
	}
	
	func stopMonitoringLocalizationChanges(_ observation: Any?) {
		
		if let nonnullObservation = observation {
			
			NotificationCenter.default.removeObserver(nonnullObservation)
		}
	}
}
