//
//  ThemeObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol ThemeObserver: ClassProtocol {
	
	func themeChanged()
}

internal extension ThemeObserver {
	
	internal func startMonitoringThemeChanges() {
		
		NotificationCenter.default.addObserver(forName: .sdkThemeChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.themeChanged()
		}
	}
	
	internal func stopMonitoringThemeChanges() {
		
		NotificationCenter.default.removeObserver(self, name: .sdkThemeChanged, object: nil)
	}
}
