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
    
    internal static func closePayment(with error: TapSDKError, _ completion: TypeAlias.ArgumentlessClosure?) {
		
        let mode =  Process.shared.transactionMode
        var status: PaymentStatus
		
        switch mode {
            
        case .purchase:         status = .chargeFailure(nil, error)
        case .authorizeCapture: status = .authorizationFailure(nil, error)
		case .cardSaving:		status = .cardSaveFailure(nil, error)
            
        }
        
        Process.shared.closePayment(with: status, fadeAnimation: false, force: true, completion: completion)
    }
    
	internal static func showAlert(for error: TapSDKError?, with title: String, message: String, retryAction: TypeAlias.ArgumentlessClosure?, report: Bool, completion: TypeAlias.BooleanClosure? = nil) {
        
        let alert = TapAlertController(title: title, message: message, preferredStyle: .alert)
		
		func hide(_ alertController: TapAlertController?, witResult result: Bool) {
			
			if let nonnullAlert = alertController {
				
				nonnullAlert.hide {
					
					completion?(result)
				}
			}
			else {
				
				completion?(result)
			}
		}
		
		let dismissAction = TapAlertController.Action(titleKey: .alert_error_btn_dismiss_title, style: .cancel) { [weak alert] (action) in
			
			hide(alert, witResult: false)
		}
		
		alert.addAction(dismissAction)
        
        if retryAction != nil {
            
            let retryAlertAction = TapAlertController.Action(titleKey: .alert_error_btn_retry_title, style: .default) { [weak alert] (action) in
				
				hide(alert, witResult: true)
				retryAction?()
			}
			
			alert.addAction(retryAlertAction)
		}
		
		#if GOSELLSDK_ERROR_REPORTING_AVAILABLE
		
		if let nonnullError = error, report {
			
			let reportAction = TapAlertController.Action(titleKey: .alert_error_btn_report_title, style: .default) { [weak alert] (action) in
				
				hide(alert, witResult: false)
				
				Reporter.report(nonnullError)
			}
			
			alert.addAction(reportAction)
		}
		
		#endif
		
		alert.show()
    }
}
