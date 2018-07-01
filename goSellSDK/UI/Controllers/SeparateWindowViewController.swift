//
//  SeparateWindowViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    TapAdditionsKit.SeparateWindowRootViewController
import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIResponder.UIResponder

internal class SeparateWindowViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func show(animated: Bool = true, parentControllerSetupClosure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController>? = nil, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let showClosure: TypeAlias.ArgumentlessClosure = {
            
            self.showOnSeparateWindow { [unowned self] (rootController) in
                
                parentControllerSetupClosure?(rootController)
                rootController.present(self, animated: animated, completion: completion)
            }
        }
        
        if let firstResponder = UIResponder.current {
            
            firstResponder.resignFirstResponder(showClosure)
        }
        else {
            
            showClosure()
        }
    }
    
    internal func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let closure: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            self?.hideKeyboard {
                
                self?.dismissFromSeparateWindow(animated, completion: completion)
            }
        }
        
        if async {
            
            DispatchQueue.main.async(execute: closure)
        }
        else {
            
            closure()
        }
    }
}
