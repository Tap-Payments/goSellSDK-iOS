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
	@objc(paymentSucceed:onSession:) optional func paymentSucceed(_ charge: Charge, on session: SessionProtocol)
    
    /// Notifies the receiver that apple payment has succeed, passing `charge` and `session` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - charge: Successful charge object.
    ///   - session: Session object. Session instance
    @objc(applePaymentSucceed:onSession:) optional func applePaymentSucceed(_ charge: String, on session: SessionProtocol)
    
    
    /// Notifies the receiver that apple payment has succeed, passing `charge` and `session` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - charge: Successful charge object.
    ///   - session: Session object. Session instance
    @objc(applePaymentTokenizationFailed:onSession:) optional func applePaymentTokenizationFailed(_ error: String, on session: SessionProtocol)
    
    
    /// Notifies the receiver that apple payment has succeed, passing `charge` and `session` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - charge: Successful charge object.
    ///   - session: Session object. Session instance
    @objc(applePaymentTokenizationSucceeded:onSession:) optional func applePaymentTokenizationSucceeded(_ token: Token, on session: SessionProtocol)
    
    
    /// Notifies the receiver that apple payment has succeed, passing `charge` and `session` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - session: Session object. Session instance
    @objc(applePaymentCanceled:) optional func applePaymentCanceled(on session: SessionProtocol)
    
	/// Notifies the receiver that authorization has succeed, passing `authorize` and `session` which has initiated authorization as arguments.
	///
	/// - Parameters:
	///   - authorize: Successful authorization object.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(authorizationSucceed:onSession:) optional func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol)
	
	/// Notifies the receiver that the card was saved.
	///
	/// - Parameters:
	///   - cardVerification: CardVerification object with the details.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(cardSaved:onSession:) optional func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol)
	
	/// Notifies the receiver that the card was tokenized.
	///
	/// - Parameters:
	///   - token: Created token.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	///   - saveCard: Defines if the customer has requested to save the card.
	@objc(cardTokenized:onSession:customerRequestedToSaveTheCard:) optional func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool)
	
	/// Notifies the receiver that charge has failed, passing `session` which has initiated the payment.
	///
	/// If `error` is `nil`, then look into `charge` object to find the cause of the issue.
	///
	/// - Parameters:
	///   - charge: Charge that has failed (if reached the stage of charging).
	///   - error: Error that has occured.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(paymentFailedWithCharge:error:onSession:) optional func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol)
	
	/// Notifies the receiver that authorization has failed, passing `session` which has initiated the authorization.
	///
	/// If `error` is `nil`, then look into `authorize` object to find the cause of the issue.
	///
	/// - Parameters:
	///   - authorize: Authorize object that has failed (if reached the stage of authorization).
	///   - error: Error that has occured.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(authorizationFailedWithAuthorize:error:onSession:) optional func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol)
	
	/// Notifies the receiver that card saving process has failed.
	///
	/// If `error` is `nil`, then look into `cardVerification` object to find the cause of the issue.
	///
	/// - Parameters:
	///   - cardVerification: Card verification object.
	///   - error: Error that has occured.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(cardSavingFailedWithCardVerification:error:onSession:) optional func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol)
	
	/// Notifies the receiver that card tokenization process has failed.
	///
	/// - Parameters:
	///   - error: Error that has occured.
	///   - session: Session object. It might be either a `PayButton` instance or Session instance if you are not using `PayButton` in your application.
	@objc(cardTokenizationFailedWithError:onSession:) optional func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol)
	
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
