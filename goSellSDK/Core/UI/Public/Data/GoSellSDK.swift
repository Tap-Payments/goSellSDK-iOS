//
//  GoSellSDK.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapApplicationV2.TapBundlePlistInfo

/// Base settings class for goSell SDK.
@objcMembers public final class GoSellSDK: NSObject {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Secret key.
	///
	/// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
	public static var secretKey: SecretKey = .empty {
		
		didSet {
			
			if self.secretKey != oldValue {
				
				self.reset()
			}
		}
	}
	
	/// SDK mode. By default, `production`.
	///
	/// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
	public static var mode: SDKMode = .production
	
	/// Returns the list of the languages supported by goSellSDK.
	public static var availableLanguages: [String] {
		
		return LocalizationManager.shared.availableLocalizations
	}
	
	/// SDK version.
	public static var sdkVersion: String {
		
		let sdkPlistInfo = TapBundlePlistInfo(bundle: .goSellSDKResources)
		return sdkPlistInfo.shortVersionString!
	}
	
	/// The language of goSellSDK interface. By default the language of your app or "en" (English) if language is not supported.
	/// - Warning: You should pass in a value from `availableLanguages` here.
	public static var language: String {
		
		get {
			
			return LocalizationManager.shared.selectedLanguage
		}
		set {
			
			guard self.availableLanguages.contains(newValue) else {
				
				print("Language \(newValue) is currently not available in goSellSDK. Using \(self.language) instead.")
				return
			}
			
			LocalizationManager.shared.selectedLanguage = newValue
		}
	}
	
	/// Resets all settings and makes the SDK to reinitialize on next usage.
	/// Might be useful when you are switching accounts. Also when you are logging the user out, although that's not required.
	public static func reset() {
		
		SettingsDataManager.resetAllSettings()
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	@available(*, unavailable) private override init() {
		
		fatalError("This class cannot be instantiated.")
	}
}
