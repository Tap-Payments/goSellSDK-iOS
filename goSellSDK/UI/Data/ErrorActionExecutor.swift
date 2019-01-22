//
//  ErrorActionExecutor.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class ErrorActionExecutor {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func closePayment(with error: TapSDKError?, _ completion: TypeAlias.ArgumentlessClosure?) {
		
        let mode =  PaymentProcess.shared.externalSession?.dataSource?.mode ?? TransactionMode.default
        var status: PaymentStatus
		
        switch mode {
            
        case .purchase:         status = .chargeFailure(nil, error)
        case .authorizeCapture: status = .authorizationFailure(nil, error)
		case .cardSaving:		status = .cardSaveFailure(error)
            
        }
        
        PaymentProcess.shared.closePayment(with: status, fadeAnimation: false, force: true, completion: completion)
    }
    
    internal static func showAlert(with title: String, message: String, retryAction: TypeAlias.ArgumentlessClosure?, completion: TypeAlias.BooleanClosure? = nil) {
        
        let alert = TapAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = TapAlertController.Action(titleKey: .alert_error_btn_dismiss_title, style: .default) { [weak alert] (action) in
			
			if let nonnullAlert = alert {
				
				nonnullAlert.hide {
					
					completion?(false)
				}
			}
			else {
				
				completion?(false)
			}
		}
		
		alert.addAction(dismissAction)
        
        if retryAction != nil {
            
            let retryAlertAction = TapAlertController.Action(titleKey: .alert_error_btn_retry_title, style: .cancel) { [weak alert] (action) in
                
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
		
		alert.show()
    }
}
