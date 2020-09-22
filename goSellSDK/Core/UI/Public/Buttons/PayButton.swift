//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapNibViewV2.TapNibView
import class 	UIKit.UIButton.UIButton
import class 	UIKit.UIView.UIView

/// Pay button.
@objcMembers public final class PayButton: TapNibView, SessionProtocol {
    
    // MARK: - Public -
    // MARK: Properties
	
	/// Payment data source.
	@IBOutlet public weak var dataSource: SessionDataSource? {
		
		didSet {
			
			self.session.dataSource = self.dataSource
		}
	}
	
	/// Payment delegate.
	@IBOutlet public weak var delegate: SessionDelegate? {
		
		get {
			
			return self.sessionDelegate.originalDelegate
		}
		set {
			
			self.sessionDelegate.originalDelegate = newValue
		}
	}
	
	@IBOutlet public weak var appearance: SessionAppearance? {
		
		didSet {
			
			self.session.appearance = self.appearance
		}
	}
	
    /// Defines if the receiver is enabled.
    @objc(enabled) public var isEnabled: Bool {
        
        @objc(isEnabled)
        get {
            
            return self.ui?.isEnabled ?? false
        }
        set {
            
            self.ui?.isEnabled = newValue
        }
    }
    
    /// Bundle to load nib from.
    public override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    // MARK: Methods
    
    /// Updates displayed state.
    public func updateDisplayedState() {
		
		self.updateAppearance()
    }
	
	/// Is called when receiver superview changes.
	public override func didMoveToSuperview() {
		
		super.didMoveToSuperview()
		
		if self.superview != nil {
			
			self.tap_updateLayoutDirectionIfRequired()
			self.layoutDirectionObserver = self.startMonitoringLayoutDirectionChanges()
		}
	}
	
	/// Notifies that the receiver is about to change its superview.
	///
	/// - Parameter newSuperview: New superview.
	public override func willMove(toSuperview newSuperview: UIView?) {
		
		super.willMove(toSuperview: newSuperview)
		
		if newSuperview == nil {
			
			self.stopMonitoringLayoutDirectionChanges(self.layoutDirectionObserver)
		}
	}
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var handler: WrappedAndTypeErased?
	
	internal var uiElement: TapButton? {
		
		return self.ui
	}
	
	internal private(set) var session: InternalSession {
		
		get {
			
			if let nonnullSession = self._session {
				
				return nonnullSession
			}
			
			let result = InternalSession(self)
			result.appearance = self.appearance
			result.dataSource = self.dataSource
			result.delegate = self.sessionDelegate
			
			self.session = result
			
			return result
		}
		set {
			
			self._session = newValue
		}
	}
	
    // MARK: - Private -
    // MARK: Properties
	
	private var _session: InternalSession?
	
	private lazy var sessionDelegate: SessionDelegateProxy = {
		
		let result = SessionDelegateProxy()
		result.middlemanDelegate = self
		
		return result
	}()
	
    @IBOutlet private weak var ui: TapButton?
	
	private var layoutDirectionObserver: NSObjectProtocol?
}

// MARK: - SessionDelegate
extension PayButton: SessionDelegate {
	
	public func sessionIsStarting(_ session: SessionProtocol) {

		self.uiElement?.startLoader()
	}

	public func sessionCancelled(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
		self.processFinished()
	}

	public func sessionHasStarted(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
	}

	public func sessionHasFailedToStart(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
		self.processFinished()
	}
	
	public func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	public func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
		
		self.processFinished()
	}
	
	public func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
		
		self.processFinished()
	}
	
	private func processFinished() {
		
		self._session = nil
	}
}

// MARK: - LayoutDirectionObserver
extension PayButton: LayoutDirectionObserver {
	
	internal var viewToUpdateLayoutDirection: UIView {
		
		return self
	}
}

// MARK: - PayButtonInternalImplementation
extension PayButton: PayButtonInternalImplementation {}
