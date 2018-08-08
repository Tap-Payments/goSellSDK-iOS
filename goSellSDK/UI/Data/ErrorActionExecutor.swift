//
//  ErrorActionExecutor.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIAlertController.UIAlertAction
import class    UIKit.UIAlertController.UIAlertController
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class ErrorActionExecutor {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func closePayment(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        PaymentDataManager.shared.closePayment(with: .failure, completion: completion)
    }
    
    internal static func showAlert(with title: String, message: String, retryAction: TypeAlias.ArgumentlessClosure? = nil, completion: TypeAlias.BooleanClosure? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                alert?.dismissFromSeparateWindow(true) {
                    
                    completion?(false)
                }
            }
        }
        
        alert.addAction(dismissAction)
        
        if let nonnullRetryAction = retryAction {
            
            let retryAlertAction = UIAlertAction(title: "Retry", style: .cancel) { [weak alert] (action) in
                
                DispatchQueue.main.async {
                    
                    alert?.dismissFromSeparateWindow(true) {
                        
                        completion?(true)
                    }
                }
                
                nonnullRetryAction()
            }
            
            alert.addAction(retryAlertAction)
        }
        
        DispatchQueue.main.async {
            
            alert.showOnSeparateWindow(true, below: UIWindowLevelStatusBar, completion: nil)
        }
    }
}
