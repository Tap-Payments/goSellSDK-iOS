//
//  PaymentDataManager+OTPViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias

// MARK: - OTPViewControllerDelegate
extension PaymentDataManager: OTPViewControllerDelegate {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController) {
        
        guard let chargeIdentifier = self.currentCharge?.identifier else { return }
        
        let loader = self.showLoadingController()
        
        APIClient.shared.requestAuthenticationForCharge(with: chargeIdentifier) { [weak self] (charge, error) in
            
            self?.handleOTPChargeResponse(charge, error: error, loader: loader, otpController: controller) {
                
                self?.otpViewControllerResendButtonTouchUpInside(controller)
            }
        }
    }
    
    internal func otpViewController(_ controller: OTPViewController, didEnter code: String) {
        
        guard let chargeIdentifier = self.currentCharge?.identifier else { return }
        
        let loader = self.showLoadingController()
        
        let authenticationDetails = ChargeAuthenticationRequest(type: .otp, value: code)
        
        APIClient.shared.authenticateCharge(with: chargeIdentifier, details: authenticationDetails) { [weak self] (charge, error) in
            
            self?.handleOTPChargeResponse(charge, error: error, loader: loader, otpController: controller) {
                
                self?.otpViewController(controller, didEnter: code)
            }
        }
    }
    
    internal func otpViewControllerDidCancel(_ controller: OTPViewController) {
        
        self.paymentCancelled()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private func handleOTPChargeResponse(_ charge: Charge?, error: TapSDKError?, loader: LoadingViewController, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        let shouldHideOTP = self.shouldHideOTP(for: charge) && error == nil
        var loaderDismissed = false
        var otpDismissed = !shouldHideOTP
        
        let dismissalCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            guard loaderDismissed && otpDismissed else { return }
            self?.handleChargeResponse(charge, error: error, retryAction: retryAction)
        }
        
        loader.hide {
            
            loaderDismissed = true
            dismissalCompletionClosure()
        }
        
        if shouldHideOTP {
            
            otpController.hide {
                
                otpDismissed = true
                dismissalCompletionClosure()
            }
        }
    }
    
    private func shouldHideOTP(for charge: Charge?) -> Bool {
        
        return charge?.authentication?.status != .initiated
    }
}
