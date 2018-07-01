//
//  UIResponder+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UIApplication.UIApplication
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView

internal extension UIResponder {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var current: UIResponder? {
        
        self.currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        
        return self.currentFirstResponder
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static weak var currentFirstResponder: UIResponder?
    
    // MARK: Methods
    
    @objc private func findFirstResponder() {
        
        if let view = self as? UIView {
            
            UIResponder.currentFirstResponder = view.firstResponder
        }
        else {
            
            UIResponder.currentFirstResponder = self
        }
    }
}
