//
//  ThemeObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol ThemeObserver: ClassProtocol {
	
	func themeChanged()
}

internal extension ThemeObserver {
	
	func startMonitoringThemeChanges() -> NSObjectProtocol {
		
		return NotificationCenter.default.addObserver(forName: .tap_sdkThemeChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.themeChanged()
		}
	}
	
	func stopMonitoringThemeChanges(_ observation: Any?) {
		
		if let nonnullObservation = observation {
		
			NotificationCenter.default.removeObserver(nonnullObservation, name: .tap_sdkThemeChanged, object: nil)
		}
	}
}
