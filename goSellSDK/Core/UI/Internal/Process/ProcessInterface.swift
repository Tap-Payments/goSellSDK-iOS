//
//  ProcessInterface.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import protocol	TapAdditionsKitV2.ClassProtocol
import struct	TapAdditionsKitV2.TypeAlias
import class PassKit.PKPaymentToken

internal protocol ProcessInterface: ClassProtocol {
	
	var process: Process { get }
	
	var buttonHandlerInterface:		TapButtonHandlerInterface	{ get }
	var dataManagerInterface:		DataManagerInterface		{ get }
	var viewModelsHandlerInterface:	ViewModelsHandlerInterface	{ get }
	var webPaymentHandlerInterface:	WebPaymentHandlerInterface	{ get }
	
	func startPayment(with paymentOption: PaymentOptionCellViewModel)
	func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption)
	func openPaymentURL(_ url: URL, for paymentOption: PaymentOption, binNumber: String?)
    func showAsyncPaymentResult(_ charge: ChargeProtocol,for paymentOption: PaymentOption)
	func continuePaymentWithCurrentChargeOrAuthorize<T: ChargeProtocol>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?)
	func continueCardSaving(with identifier: String, paymentOption: PaymentOption, binNumber: String?, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?)
	func showPaymentController()
	
	func loadingControllerFrame(coveringHeader: Bool) -> CGRect
	func showLoadingController(_ coveringHeader: Bool) -> LoadingViewController
	
	func paymentSuccess(with chargeOrAuthorize: ChargeProtocol)
	func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?)
	
	func cardSavingSuccess(with cardVerification: CardVerification)
	func cardSavingFailure(with cardVerification: CardVerification, error: TapSDKError?)
	
	func cardTokenizationSuccess(with token: Token, customerRequestedToSaveCard: Bool)
	func cardTokenizationFailure(with error: TapSDKError)
}

internal protocol ProcessGenericInterface: ProcessInterface {
	
	associatedtype HandlerMode: ProcessMode
	
	init(process: Process)
}
