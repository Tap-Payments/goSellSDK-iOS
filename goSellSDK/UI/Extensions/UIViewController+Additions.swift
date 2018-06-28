//
//  UIViewController+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.UIViewController.UIViewController

internal extension UIViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func hideKeyboard(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        if let responder = self.view.firstResponder {
            
            responder.resignFirstResponder(completion)
        }
        else {
            
            completion()
        }
    }
}
