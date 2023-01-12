//
//  InternalSessionImplementation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIResponder.UIResponder
import PassKit

internal protocol InternalSessionImplementation: SessionProtocol {}


internal extension InternalSessionImplementation {
	
	var implementationCanStart: Bool {
		
		return Process.Validation.canStart(using: self)
	}
	
	func implementationStart() -> Bool {
		
		guard self.implementationCanStart else { return false }
		
		DispatchQueue.main.async {
			
			UIResponder.tap_resign()
		}
		
		return Process.shared.start(self)
	}
    
    
    func implementationApplyPayStart(ui:Bool = false) -> Bool {
        
        guard self.implementationCanStart else { return false }
        
        DispatchQueue.main.async {
            
            UIResponder.tap_resign()
        }
        if !ui
        {
            return Process.shared.startApplePay(self)
        }else
        {
            startAppleKit()
            return true
        }
    }
    
    
    func startAppleKit()
    {
        let result = Process.shared.dataManagerInterface.loadPaymentOptions(for: self, onLoaded: {
            print("WE ARE READY")
            let paymentOption = Process.shared.dataManagerInterface.paymentOptions(of: .apple)
            let request = Process.shared.dataManagerInterface.createApplePayRequest()
        }, showPaymentController: false)
        //let paymentOption = Process.shared.dataManagerInterface.paymentOptions(of: .apple)
        /*let request = Process.shared.dataManagerInterface.createApplePayRequest()
        
        let applePayUI:ApplePayUI = ApplePayUI(completionHandler: { [unowned self] Result in
            self.delegate?.applePaymentSucceed?(Result, on: self)
        }) {
            self.delegate?.applePaymentCanceled?(on: self)
        }
        applePayUI.showApplePay(with: request)*/
        
    }
	
	func implementationCalculateDisplayedAmount() -> NSDecimalNumber? {
		
		guard self.implementationCanStart else { return nil }
		return Process.NonGenericAmountCalculator.totalAmount(for: self)
	}
}


class ApplePayUI:NSObject,PKPaymentAuthorizationViewControllerDelegate
{
    
    let completionHandler: ((String)->())
    let cancelHandler: (()->())
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {[weak self] in
            if let cancelHandler = self?.cancelHandler{
                cancelHandler()
            }
        }
    }
    
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        
        let paymentMethod:String = payment.token.paymentMethod.network?.rawValue ?? ""
        let transactionID:String = payment.token.transactionIdentifier
        
        let token = String(data: payment.token.paymentData, encoding: .utf8)
        let utf8str = token!.data(using: .utf8)
        
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        controller.dismiss(animated: true) {[weak self] in
            if let base64Encoded = utf8str?.base64EncodedString()
            {
                if let completeBlock = self?.completionHandler{
                    completeBlock("Method: \(paymentMethod.uppercased())\nTransID: \(transactionID)\nEncodedData: \(base64Encoded)")
                }
            }
        }
        //completion(PKPaymentAuthorizationStatus.success)
        // payment.billingContact.
        
    }
    
    init(completionHandler: @escaping ((String)->()),cancelHandler: @escaping (()->())) {
        self.completionHandler = completionHandler
        self.cancelHandler = cancelHandler
    }
    
    func showApplePay(with applePayRequest:PKPaymentRequest)
    {
        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: applePayRequest)
        {
            applePayController.delegate = self
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                // topController should now be your topmost view controller
                topController.present(applePayController, animated: true, completion: nil)
            }
        }
    }
}
