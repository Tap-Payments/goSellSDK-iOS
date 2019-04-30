//
//  Notification.Name+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UITextField.UITextField

#if swift(>=4.2)
import class	UIKit.UIResponder.UIResponder
#else
import var		UIKit.UIResponder.UIKeyboardWillChangeFrameNotification
import var		UIKit.UIResponder.UIKeyboardWillShowNotification
import var		UIKit.UITextField.UITextFieldTextDidChangeNotification
#endif

internal extension Notification.Name {
	
	static let tap_sdkLanguageChanged			= Notification.Name("TapSDKLanguageChangedNotification")
	static let tap_sdkLayoutDirectionChanged	= Notification.Name("TapSDKLayoutDirectionChangedNotification")
	static let tap_sdkThemeChanged				= Notification.Name("TapSDKThemeChangedNotification")
    static let tap_paymentOptionsModelsUpdated	= Notification.Name("TapPaymentOptionsUpdatedNotification")
    static let tap_payButtonStateChanged		= Notification.Name("TapPayButtonStateChangedNotification")
	
	static let tap_textDidChangeNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UITextField.textDidChangeNotification
		
		#else
		
		return .UITextFieldTextDidChange
		
		#endif
	}()
	
	static let tap_keyboardWillShowNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UIResponder.keyboardWillShowNotification
		
		#else
		
		return .UIKeyboardWillShow
		
		#endif
	}()
	
	static let tap_keyboardWillChangeFrameNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UIResponder.keyboardWillChangeFrameNotification
		
		#else
		
		return .UIKeyboardWillChangeFrame
		
		#endif
	}()
}
