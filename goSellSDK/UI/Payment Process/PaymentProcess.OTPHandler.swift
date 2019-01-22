//
//  PaymentProcess.OTPHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal extension PaymentProcess {
	
	internal class OTPHandler: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func showOTPScreen(with phoneNumber: String) {
			
			ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeFullscreen {
				
				let otpControllerFrame = self.process.loadingControllerFrame(coveringHeader: false)
				OTPViewController.show(with: otpControllerFrame.minY, with: phoneNumber, delegate: self)
			}
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
		
		// MARK: Methods
		
		private func handleAuthenticationResponse<T: ChargeProtocol>(_ authenticatable: T?, error: TapSDKError?, loader: LoadingViewSupport, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			
			let shouldHideOTP = self.shouldHideOTP(for: authenticatable) && error == nil
			var loaderDismissed = false
			var otpDismissed = !shouldHideOTP
			
			let dismissalCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
				
				guard loaderDismissed && otpDismissed else { return }
				self?.process.dataManager.handleChargeOrAuthorizeResponse(authenticatable, error: error, retryAction: retryAction)
			}
			
			loader.hideLoader {
				
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
}

// MARK: - OTPViewControllerDelegate
extension PaymentProcess.OTPHandler: OTPViewControllerDelegate {
	
	internal func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController) {
		
		guard self.process.dataManager.currentChargeOrAuthorize is Charge || self.process.dataManager.currentChargeOrAuthorize is Authorize else { return }
		
		LoadingView.show(in: controller, animated: true, descriptionText: nil)
		
		if let chargeObject = self.process.dataManager.currentChargeOrAuthorize as? Charge {
			
			APIClient.shared.requestAuthentication(for: chargeObject) { [weak self] (response, error) in
				
				guard let strongSelf = self else {
					
					controller.hideLoader()
					return
				}
				
				strongSelf.handleAuthenticationResponse(response, error: error, loader: controller, otpController: controller) { [weak strongSelf] in
					
					strongSelf?.otpViewControllerResendButtonTouchUpInside(controller)
				}
			}
		}
		else if let authorizeObject = self.process.dataManager.currentChargeOrAuthorize as? Authorize {
			
			APIClient.shared.requestAuthentication(for: authorizeObject) { [weak self] (response, error) in
				
				guard let strongSelf = self else {
					
					controller.hideLoader()
					return
				}
				
				strongSelf.handleAuthenticationResponse(response, error: error, loader: controller, otpController: controller) { [weak strongSelf] in
					
					strongSelf?.otpViewControllerResendButtonTouchUpInside(controller)
				}
			}
		}
		else {
			
			controller.hideLoader()
		}
	}
	
	internal func otpViewController(_ controller: OTPViewController, didEnter code: String) {
		
		guard self.process.dataManager.currentChargeOrAuthorize is Charge || self.process.dataManager.currentChargeOrAuthorize is Authorize else { return }
		
		let loader = self.process.showLoadingController(false)
		let authenticationDetails = AuthenticationRequest(type: .otp, value: code)
		
		if let chargeObject = self.process.dataManager.currentChargeOrAuthorize as? Charge {
			
			APIClient.shared.authenticate(chargeObject, details: authenticationDetails) { [weak self] (response, error) in
				
				guard let strongSelf = self else { return }
				
				strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
					
					strongSelf?.otpViewController(controller, didEnter: code)
				}
			}
		}
		else if let authorizeObject = self.process.dataManager.currentChargeOrAuthorize as? Authorize {
			
			APIClient.shared.authenticate(authorizeObject, details: authenticationDetails) { [weak self] (response, error) in
				
				guard let strongSelf = self else { return }
				
				strongSelf.handleAuthenticationResponse(response, error: error, loader: loader, otpController: controller) { [weak strongSelf] in
					
					strongSelf?.otpViewController(controller, didEnter: code)
				}
			}
		}
	}
	
	internal func otpViewControllerDidCancel(_ controller: OTPViewController) {
		
		self.process.dataManager.paymentCancelled()
	}
}
