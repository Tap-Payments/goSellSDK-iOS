//
//  LocalizationManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey
import class	TapBundleLocalization.LocalizationProvider
import class	TapResponderChainInputViewV2.TapResponderChainInputView
import enum		UIKit.UIInterface.UIUserInterfaceLayoutDirection

/// Localization provider.
internal final class LocalizationManager {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var availableLocalizations: [String] {
		
		return self.provider.availableLocalizations
	}
	
	internal var layoutDirection: UIUserInterfaceLayoutDirection {
		
		return self.provider.suggestedInterfaceLayoutDirection
	}
	
	internal var selectedLocale: Locale {
		
		return self.provider.selectedLocale
	}
	
	internal var selectedLanguage: String {
		
		get {
		
			return self.provider.selectedLanguage
		}
		set {
		
			guard self.selectedLanguage != newValue else { return }
		
			let oldValue = self.provider.selectedLanguage
			
			self.provider.selectedLanguage = newValue
			
			NotificationCenter.default.post(name: .tap_sdkLanguageChanged, object: nil)
			
			#if GOSELLSDK_ERROR_REPORTING_AVAILABLE
			
				Reporter.language = newValue
			
			#endif
			
			self.postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo: oldValue)
		}
	}
	
	// MARK: Methods
	
	internal func localizedString(for key: LocalizationKey) -> String {
		
		return self.provider.localizedString(for: key)
	}
	
	internal func localizedErrorTitle(for error: ErrorCode) -> String {
		
		guard let key = self.alertTitleKey(for: error) else {
			
			print("There is no localization error title for error \(error.rawValue). Please report this problem to developer.")
			return self.localizedString(for: .alert_error_9999_title)
		}
		
		return self.localizedString(for: key)
	}
	
	internal func localizedErrorMessage(for error: ErrorCode) -> String {
		
		guard let key = self.alertMessageKey(for: error) else {
			
			print("There is no localization error message for error \(error.rawValue). Please report this problem to developer.")
			return self.localizedString(for: .alert_error_9999_message)
		}
		
		return self.localizedString(for: key)
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let localeFolderExtension = "lproj"
		
		//@available(*, unavailable) private init() { }
	}
	
	// MARK: Properties
	
	private static var storage: LocalizationManager?
	
	private lazy var provider = LocalizationProvider(bundle: .goSellSDKResources)
	
	// MARK: Methods
	
	private init() {
		
		self.updateResponderChainInputViewLayoutDirection()
	}
	
	private func postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo oldLanguage: String) {
		
		let oldDirection: UIUserInterfaceLayoutDirection = Locale.characterDirection(forLanguage: oldLanguage) == .rightToLeft ? .rightToLeft : .leftToRight
		if oldDirection != self.layoutDirection {
			
			NotificationCenter.default.post(name: .tap_sdkLayoutDirectionChanged, object: nil)
			
			self.updateResponderChainInputViewLayoutDirection()
		}
	}
	
	private func updateResponderChainInputViewLayoutDirection()  {
		
		TapResponderChainInputView.globalSettings.hasRTLLayout = self.layoutDirection == .rightToLeft
	}
	
	private func alertTitleKey(for error: ErrorCode) -> LocalizationKey? {
		
		let raw = "alert_error_\(error.rawValue)_title"
		return LocalizationKey(raw)
	}
	
	private func alertMessageKey(for error: ErrorCode) -> LocalizationKey? {
		
		let raw = "alert_error_\(error.rawValue)_message"
		return LocalizationKey(raw)
	}
}

// MARK: - Singleton
extension LocalizationManager: Singleton {
	
	internal static var shared: LocalizationManager {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let result = LocalizationManager()
		self.storage = result
		
		return result
	}
}

// MARK: - StaticlyDestroyable
extension LocalizationManager: StaticlyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
}

// MARK: - ImmediatelyDestroyable
extension LocalizationManager: ImmediatelyDestroyable {
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}
