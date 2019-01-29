//
//  SessionDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Payment delegate.
@objc public protocol SessionDelegate: class, NSObjectProtocol {
    
    /// Notifies the receiver that payment has succeed, passing `charge` and `session` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - charge: Successful charge object.
    ///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
    @objc optional func paymentSucceed(_ charge: Charge, on session: SessionProtocol)
    
    /// Notifies the receiver that authorization has succeed, passing `authorize` and `session` which has initiated authorization as arguments.
    ///
    /// - Parameters:
    ///   - authorize: Successful authorization object.
    ///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
    @objc optional func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol)
    
    /// Notifies the receiver that charge has failed, passing `session` which has initiated the payment.
    ///
    /// - Parameters:
    ///   - charge: Charge that has failed (if reached the stage of charging).
    ///   - error: Error that has occured.
    ///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
    @objc optional func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol)
    
    /// Notifies the receiver that authorization has failed, passing `session` which has initiated the authorization.
    ///
    /// - Parameters:
    ///   - authorize: Authorize object that has failed (if reached the stage of authorization).
    ///   - error: Error that has occured.
    ///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
    @objc optional func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol)
	
	@objc optional func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol)
	
	/// Notifies the receiver that card saving process has failed.
	///
	/// - Parameters:
	///   - error: Error that has occured.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc optional func cardSavingFailed(with error: TapSDKError?, on session: SessionProtocol)
	
	/// Notifies the receiver that session is about to start and has not yet shown the SDK UI.
	///
	/// You might want to use this method if you are not using `PayButton` in your application and want to show a loader before SDK UI appears on the screen.
	///
	/// - Parameter session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc optional func sessionIsStarting(_ session: SessionProtocol)
	
	/// Notifies the receiver that session has successfully started and shown the SDK UI on the screen.
	///
	/// You might want to use this method if you are not using `PayButton` in your application and want to hide a loader after SDK UI has appeared on the screen.
	///
	/// - Parameter session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc optional func sessionHasStarted(_ session: SessionProtocol)
	
	/// Notifies the receiver that session has failed to start and will not show the SDK UI on the screen.
	///
	/// You might want to use this method if you are not using `PayButton` in your application and want to hide a loader because the session has failed.
	/// For the actual failure cause please implement other methods from this protocol and listen to the callbacks.
	///
	/// - Parameter session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc optional func sessionHasFailedToStart(_ session: SessionProtocol)
	
	/// Notifies the receiver that session has been cancelled by the user.
	///
	/// - Parameter session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc optional func sessionCancelled(_ session: SessionProtocol)
}
