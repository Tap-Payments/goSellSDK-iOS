//
//  InputFieldObserver.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import ObjectiveC

import struct   Foundation.NSNotification.Notification
import class    Foundation.NSNotification.NotificationCenter
import class    UIKit.UITextField.UITextField
import class    UIKit.UITextView.UITextView

@objc internal protocol InputFieldObserver {
    
    func inputFieldTextChanged(_ notification: Notification)
}

internal extension InputFieldObserver {
    
    internal func addInputFieldTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    internal func removeInputFieldTextChangeObserver() {
        
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
