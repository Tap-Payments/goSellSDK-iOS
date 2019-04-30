//
//  Notification.Name+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSNotification.Notification

#if swift(>=4.2)
import class	UIKit.UIResponder.UIResponder
import class	UIKit.UITextField.UITextField
import class	UIKit.UITextView.UITextView
#else
import var		UIKit.UIResponder.UIKeyboardWillChangeFrameNotification
import var		UIKit.UITextField.UITextFieldTextDidChangeNotification
import var		UIKit.UITextView.UITextViewTextDidChangeNotification
#endif

internal extension Notification.Name {
	
	// MARK: - Internal -
	// MARK: Properties
	
	static let tap_keyboardWillChangeFrameNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UIResponder.keyboardWillChangeFrameNotification
		
		#else
		
		return .UIKeyboardWillChangeFrame
		
		#endif
	}()
	
	static let tap_textFieldTextDidChangeNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UITextField.textDidChangeNotification
		
		#else
		
		return .UITextFieldTextDidChange
		
		#endif
	}()
	
	static let tap_textViewTextDidChangeNotificationName: Notification.Name = {
		
		#if swift(>=4.2)
		
		return UITextView.textDidChangeNotification
		
		#else
		
		return .UITextViewTextDidChange
		
		#endif
	}()
}
