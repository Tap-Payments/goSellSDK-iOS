//
//  InputFieldObserver.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import ObjectiveC

import struct Foundation.NSNotification.Notification
import class Foundation.NSNotification.NotificationCenter

@objc internal protocol InputFieldObserver {
    
    func inputFieldTextChanged(_ notification: Notification)
}

internal extension InputFieldObserver {
    
    internal func addInputFieldTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    internal func removeInputFieldTextChangeObserver() {
        
        NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: nil)
    }
}
