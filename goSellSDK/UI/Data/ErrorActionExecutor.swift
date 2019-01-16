//
//  ErrorActionExecutor.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIAlertController.UIAlertAction
import class    UIKit.UIAlertController.UIAlertController
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class ErrorActionExecutor {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func closePayment(with error: TapSDKError, _ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        let mode = PaymentDataManager.shared.externalDataSource?.mode ?? .purchase
        var status: PaymentStatus
        switch mode {
            
        case .purchase:         status = .chargeFailure(nil, error)
        case .authorizeCapture: status = .authorizationFailure(nil, error)
            
        }
        
        PaymentDataManager.shared.closePayment(with: status, fadeAnimation: false, force: true, completion: completion)
    }
    
    internal static func showAlert(with title: String, message: String, retryAction: TypeAlias.ArgumentlessClosure?, completion: TypeAlias.BooleanClosure? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(titleKey: .alert_error_btn_dismiss_title, style: .default) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                if let nonnullAlert = alert {
                    
                    nonnullAlert.tap_dismissFromSeparateWindow(true) {
                        
                        completion?(false)
                    }
                }
                else {
                    
                    completion?(false)
                }
            }
        }
        
        alert.addAction(dismissAction)
        
        if retryAction != nil {
            
            let retryAlertAction = UIAlertAction(titleKey: .alert_error_btn_retry_title, style: .cancel) { [weak alert] (action) in
                
                DispatchQueue.main.async {
                    
                    if let nonnullAlert = alert {
                        
                        nonnullAlert.tap_dismissFromSeparateWindow(true) {
                            
                            completion?(true)
                        }
                    }
                    else {
                        
                        completion?(true)
                    }
                }
                
                retryAction?()
            }
            
            alert.addAction(retryAlertAction)
        }
        
        DispatchQueue.main.async {
			
			alert.tap_showOnSeparateWindow(below: .statusBar) { [unowned alert] (separateWindowRootController) in
				
				let supportedOrientations = InterfaceOrientationManager.shared.supportedInterfaceOrientations(for: separateWindowRootController)
				let canAutorotate = InterfaceOrientationManager.shared.viewControllerShouldAutorotate(separateWindowRootController)
				let preferredOrientation = InterfaceOrientationManager.shared.preferredInterfaceOrientationForPresentation(of: separateWindowRootController)
				
				separateWindowRootController.canAutorotate					= canAutorotate
				separateWindowRootController.allowedInterfaceOrientations	= supportedOrientations
				separateWindowRootController.preferredInterfaceOrientation	= preferredOrientation
				
				separateWindowRootController.present(alert, animated: true, completion: nil)
			}
        }
    }
}
