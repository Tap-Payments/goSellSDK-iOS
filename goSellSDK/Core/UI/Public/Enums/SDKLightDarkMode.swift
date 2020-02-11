//
//  SDKLightDarkMode.swift
//  goSellSDK
//
//  Created by Osama Rabie on 21/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// SDK loght dark mode for iOS 13+
///
/// - light: The normal light mode
/// - dark: The default dark mode
/// - default: Default mode is light
@objc public enum SDKLightDarkMode: Int, CaseIterable {
	
	/// Dark mode.
	@objc(DarkMode) case darkMode
	
	/// Light mode.
	@objc(LightMode) case lightMode
}

// MARK: - CustomStringConvertible
extension SDKLightDarkMode: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
			
		case .darkMode :		return "DarkMode"
		case .lightMode:		return "LightMode"
		}
	}
}

