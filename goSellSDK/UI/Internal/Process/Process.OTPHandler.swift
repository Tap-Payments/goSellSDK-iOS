//
//  PaymentProcess.OTPHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal protocol OTPHandlerInterface {
	
	func handleAuthenticationResponse<T: ChargeProtocol>(_ authenticatable: T?, error: TapSDKError?, loader: LoadingViewSupport, otpController: OTPViewController, retryAction: @escaping TypeAlias.ArgumentlessClosure)
}

internal extension Process {
	
	internal final class OTPHandler: OTPHandlerInterface, OTPViewControllerDelegate {
		
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
		
		internal func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController) {}
		
		internal func otpViewController(_ controller: OTPViewController, didEnter code: String) {}
		
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
