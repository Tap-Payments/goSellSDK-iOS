//
//  PaymentProcess.OTPHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias

internal protocol OTPHandlerInterface {
	
	func handleAuthenticationResponse<T: ChargeProtocol>(_ authenticatable: T?, error: TapSDKError?, loader: LoadingViewSupport, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure)
}

internal extension Process {
	
	final class OTPHandler: OTPHandlerInterface, OTPViewControllerDelegate {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface
		
		// MARK: Methods
		
		internal init(process: ProcessInterface) {
			
			self.process = process
		}
		
		internal func showOTPScreen(with phoneNumber: String) {
			
			ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeFullscreen {
				
				let otpControllerFrame = self.process.loadingControllerFrame(coveringHeader: false)
				OTPViewController.show(with: otpControllerFrame.minY, with: phoneNumber, delegate: self)
			}
		}
		
		internal func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController) {
			
			guard let currentChargeOrAuthorize = self.process.dataManagerInterface.currentChargeOrAuthorize else { return }
			
			guard currentChargeOrAuthorize is Charge || currentChargeOrAuthorize is Authorize else { return }
			
			LoadingView.show(in: controller, animated: true, descriptionText: nil)
			
			if let chargeObject = currentChargeOrAuthorize as? Charge {
				
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
			else if let authorizeObject = currentChargeOrAuthorize as? Authorize {
				
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
			
			guard let currentChargeOrAuthorize = self.process.dataManagerInterface.currentChargeOrAuthorize else { return }
			
			guard currentChargeOrAuthorize is Charge || currentChargeOrAuthorize is Authorize else { return }
			
			LoadingView.show(in: controller, animated: true, descriptionText: nil)
			
			let authenticationDetails = AuthenticationRequest(type: .otp, value: code)
			
			if let chargeObject = currentChargeOrAuthorize as? Charge {
				
				APIClient.shared.authenticate(chargeObject, details: authenticationDetails) { [weak self] (response, error) in
					
					guard let strongSelf = self else { return }
					
					strongSelf.handleAuthenticationResponse(response, error: error, loader: controller, otpController: controller) { [weak strongSelf] in
						
						strongSelf?.otpViewController(controller, didEnter: code)
					}
				}
			}
			else if let authorizeObject = currentChargeOrAuthorize as? Authorize {
				
				APIClient.shared.authenticate(authorizeObject, details: authenticationDetails) { [weak self] (response, error) in
					
					guard let strongSelf = self else { return }
					
					strongSelf.handleAuthenticationResponse(response, error: error, loader: controller, otpController: controller) { [weak strongSelf] in
						
						strongSelf?.otpViewController(controller, didEnter: code)
					}
				}
			}
		}
		
		internal func otpViewControllerDidCancel(_ controller: OTPViewController) {
			
			self.process.dataManagerInterface.paymentCancelled()
		}
		
		// MARK: - Private -
		// MARK: Methods
		
		private func shouldHideOTP(for authenticatable: Authenticatable?) -> Bool {
			
			return authenticatable?.authentication?.status != .initiated
		}
		
		internal func handleAuthenticationResponse<T: ChargeProtocol>(_ authenticatable: T?, error: TapSDKError?, loader: LoadingViewSupport, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
			
			let shouldHideOTP = self.shouldHideOTP(for: authenticatable) && error == nil
			var loaderDismissed = false
			var otpDismissed = !shouldHideOTP
			
			let dismissalCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
				
				guard loaderDismissed && otpDismissed else { return }
				self?.process.dataManagerInterface.handleChargeOrAuthorizeResponse(authenticatable, error: error, retryAction: retryAction)
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
	}
}
