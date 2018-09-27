//
//  goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Base settings class for goSell SDK.
@objcMembers public final class goSellSDK: NSObject {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// SDK mode. By default, `production`.
	///
	/// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
	public static var mode: SDKMode = .production
	
	/// Secret key.
	///
	/// - Warning: Don't change while the payment is in progress or the payment process and status will be undefined.
	public static var secretKey: SecretKey = .empty
	
	/// Returns the list of the languages supported by goSellSDK.
	public static var availableLanguages: [String] {
		
		return LocalizationProvider.availableLocalizations
	}
	
	/// The language of goSellSDK interface. By default the language of your app or "en" (English) if language is not supported.
	/// - Warning: You should pass in a value from `availableLanguages` here.
	public static var language: String {
		
		get {
			
			return LocalizationProvider.shared.selectedLanguage
		}
		set {
			
			guard self.availableLanguages.contains(newValue) else {
				
				return
			}
			
			LocalizationProvider.shared.selectedLanguage = newValue
		}
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	@available(*, unavailable) private override init() {
		
		fatalError("This class cannot be instantiated.")
	}
}
