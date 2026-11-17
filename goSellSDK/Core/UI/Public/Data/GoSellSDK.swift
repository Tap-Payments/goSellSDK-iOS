//
//  GoSellSDK.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit

/// Base settings class for goSell SDK.
@objcMembers public final class GoSellSDK: NSObject {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Secret key.
	///
	/// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
	public static var secretKey: SecretKey = .empty {
		
		didSet {
            UIFont.loadSARFont()

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
		
		return SDKVersion.current
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

/// The goSellSDK version reported to the API and through `GoSellSDK.sdkVersion`.
///
/// Reading it from a bundle's Info.plist doesn't work everywhere: Swift Package Manager
/// resource bundles carry no version, and with static linking `Bundle(for:)` returns the
/// host app's bundle.
internal enum SDKVersion {

    /// Keep in sync with `goSellSDK.version` in goSellSDK.podspec.
    internal static let current = "2.4.0"
}
