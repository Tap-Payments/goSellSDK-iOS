//
//  Notification.Name+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Notification.Name {
	
	static let tap_sdkLanguageChanged			= Notification.Name("TapSDKLanguageChangedNotification")
	static let tap_sdkLayoutDirectionChanged	= Notification.Name("TapSDKLayoutDirectionChangedNotification")
	static let tap_sdkThemeChanged				= Notification.Name("TapSDKThemeChangedNotification")
    static let tap_paymentOptionsModelsUpdated = Notification.Name("TapPaymentOptionsUpdatedNotification")
    static let tap_payButtonStateChanged       = Notification.Name("TapPayButtonStateChangedNotification")
}
