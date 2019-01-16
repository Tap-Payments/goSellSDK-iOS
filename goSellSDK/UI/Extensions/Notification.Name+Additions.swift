//
//  Notification.Name+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Notification.Name {
	
	internal static let tap_sdkLanguageChanged			= Notification.Name("TapSDKLanguageChangedNotification")
	internal static let tap_sdkLayoutDirectionChanged	= Notification.Name("TapSDKLayoutDirectionChangedNotification")
	internal static let tap_sdkThemeChanged				= Notification.Name("TapSDKThemeChangedNotification")
    internal static let tap_paymentOptionsModelsUpdated = Notification.Name("TapPaymentOptionsUpdatedNotification")
    internal static let tap_payButtonStateChanged       = Notification.Name("TapPayButtonStateChangedNotification")
}
