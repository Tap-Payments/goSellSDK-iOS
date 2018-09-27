//
//  LocalizationProvider.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class	TapResponderChainInputView.TapResponderChainInputView
import enum		UIKit.UIInterface.UIUserInterfaceLayoutDirection

internal final class LocalizationProvider {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal static var availableLocalizations: [String] {
		
		return self.bundle.localizations
	}
	
	internal var layoutDirection: UIUserInterfaceLayoutDirection {
		
		return Locale.characterDirection(forLanguage: self.selectedLanguage) == .rightToLeft ? .rightToLeft : .leftToRight
	}
	
	internal private(set) lazy var selectedLocale: Locale = Locale(identifier: self.selectedLanguage)
	
	internal var selectedLanguage: String = LocalizationProvider.obtainInitialSDKLanguage() {
		
		didSet {
			
			guard self.selectedLanguage != oldValue else { return }
			
			self.selectedLocale = Locale(identifier: self.selectedLanguage)
			self.selectedLanguageBundle = self.obtainBundleForCurrentLanguage()
			
			NotificationCenter.default.post(name: .sdkLanguageChanged, object: nil)
			
			self.postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo: oldValue)
		}
	}
	
	// MARK: Methods
	
	internal func localizedString(for key: LocalizationKey) -> String {
		
		return self.selectedLanguageBundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let localeFolderExtension = "lproj"
		
		@available(*, unavailable) private init() {}
	}
	
	// MARK: Properties
	
	private static var storage: LocalizationProvider?
	
	private static var bundle: Bundle { return .goSellSDKResources }
	
	private lazy var selectedLanguageBundle: Bundle = self.obtainBundleForCurrentLanguage()
	
	// MARK: Methods
	
	private init() {
		
		self.updateResponderChainInputViewLayoutDirection()
	}
	
	private static func obtainInitialSDKLanguage() -> String {
		
		return LocalizationProvider.bundle.developmentLocalization ?? Locale.LocaleIdentifier.en
	}
	
	private func obtainBundleForCurrentLanguage() -> Bundle {
		
		guard let path = LocalizationProvider.bundle.path(forResource: self.selectedLanguage, ofType: Constants.localeFolderExtension) else {
			
			fatalError("goSellSDK does not support language \(self.selectedLanguage).")
		}
		
		guard let result = Bundle(path: path) else {
			
			fatalError("Failed to load \(self.selectedLanguage) bundle.")
		}
		
		return result
	}
	
	private func postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo oldLanguage: String) {
		
		let oldDirection: UIUserInterfaceLayoutDirection = Locale.characterDirection(forLanguage: oldLanguage) == .rightToLeft ? .rightToLeft : .leftToRight
		if oldDirection != self.layoutDirection {
			
			NotificationCenter.default.post(name: .sdkLayoutDirectionChanged, object: nil)
			
			self.updateResponderChainInputViewLayoutDirection()
		}
	}
	
	private func updateResponderChainInputViewLayoutDirection()  {
		
		TapResponderChainInputView.globalSettings.hasRTLLayout = self.layoutDirection == .rightToLeft
	}
}

// MARK: - Singleton
extension LocalizationProvider: Singleton {
	
	internal static var shared: LocalizationProvider {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let result = LocalizationProvider()
		self.storage = result
		
		return result
	}
}

// MARK: - StaticlyDestroyable
extension LocalizationProvider: StaticlyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
}

// MARK: - ImmediatelyDestroyable
extension LocalizationProvider: ImmediatelyDestroyable {
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}
