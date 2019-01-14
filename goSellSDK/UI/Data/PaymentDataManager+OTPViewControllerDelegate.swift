//
//  PaymentDataManager+OTPViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias

// MARK: - OTPViewControllerDelegate
extension PaymentDataManager: OTPViewControllerDelegate {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController) {
        
        guard self.currentChargeOrAuthorize is Charge || self.currentChargeOrAuthorize is Authorize else { return }
        
        let loader = self.showLoadingController(false)
        
        if let chargeObject = self.currentChargeOrAuthorize as? Charge {
            
            APIClient.shared.requestAuthentication(for: chargeObject) { [weak self] (response, error) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
                    
                    strongSelf?.otpViewControllerResendButtonTouchUpInside(controller)
                }
            }
        }
        else if let authorizeObject = self.currentChargeOrAuthorize as? Authorize {
            
            APIClient.shared.requestAuthentication(for: authorizeObject) { [weak self] (response, error) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
                    
                    strongSelf?.otpViewControllerResendButtonTouchUpInside(controller)
                }
            }
        }
    }
    
    internal func otpViewController(_ controller: OTPViewController, didEnter code: String) {
        
        guard self.currentChargeOrAuthorize is Charge || self.currentChargeOrAuthorize is Authorize else { return }
        
        let loader = self.showLoadingController(false)
        let authenticationDetails = AuthenticationRequest(type: .otp, value: code)
        
        if let chargeObject = self.currentChargeOrAuthorize as? Charge {
            
            APIClient.shared.authenticate(chargeObject, details: authenticationDetails) { [weak self] (response, error) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
                    
                    strongSelf?.otpViewController(controller, didEnter: code)
                }
            }
        }
        else if let authorizeObject = self.currentChargeOrAuthorize as? Authorize {
            
            APIClient.shared.authenticate(authorizeObject, details: authenticationDetails) { [weak self] (response, error) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
                    
                    strongSelf?.otpViewController(controller, didEnter: code)
                }
            }
        }
    }
    
    internal func otpViewControllerDidCancel(_ controller: OTPViewController) {
        
        self.paymentCancelled()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private func handleAuthenticationResponse<T: ChargeProtocol>(_ authenticatable: T?, error: TapSDKError?, loader: LoadingViewController, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        let shouldHideOTP = self.shouldHideOTP(for: authenticatable) && error == nil
        var loaderDismissed = false
        var otpDismissed = !shouldHideOTP
        
        let dismissalCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            guard loaderDismissed && otpDismissed else { return }
            self?.handleChargeOrAuthorizeResponse(authenticatable, error: error, retryAction: retryAction)
        }
        
        loader.hide(animated: true, async: true, fromDestroyInstance: false) {
            
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
    
    private func shouldHideOTP(for authenticatable: Authenticatable?) -> Bool {
        
        return authenticatable?.authentication?.status != .initiated
    }
}
