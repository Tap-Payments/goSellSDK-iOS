//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapNibView.TapNibView
import class 	UIKit.UIButton.UIButton
import class 	UIKit.UIView.UIView

/// Pay button.
@objcMembers public final class PayButton: TapNibView {
    
    // MARK: - Public -
    // MARK: Properties
    
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
	
	public override func didMoveToSuperview() {
		
		super.didMoveToSuperview()
		
		if self.superview != nil {
			
			self.tap_updateLayoutDirectionIfRequired()
			self.startMonitoringLayoutDirectionChanges()
		}
	}
	
	public override func willMove(toSuperview newSuperview: UIView?) {
		
		super.willMove(toSuperview: newSuperview)
		
		if newSuperview == nil {
			
			self.stopMonitoringLayoutDirectionChanges()
		}
	}
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var handler: WrappedAndTypeErased?
	
	internal var uiElement: TapButton? {
		
		return self.ui
	}
	
	internal private(set) lazy var session: InternalSession = {
		
		let result = InternalSession(self)
		result.delegate = self.sessionDelegate
		
		return result
	}()
	
    // MARK: - Private -
    // MARK: Properties
	
	private lazy var sessionDelegate: SessionDelegateProxy = {
		
		let result = SessionDelegateProxy()
		result.middlemanDelegate = self
		
		return result
	}()
	
    @IBOutlet private weak var ui: TapButton?
}

// MARK: - SessionProtocol
extension PayButton: SessionProtocol {
	
	/// Payment data source.
	@IBOutlet public weak var dataSource: SessionDataSource? {
		
		get {
			
			return self.session.dataSource
		}
		set {
			
			self.session.dataSource = newValue
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
		
		get {
			
			return self.session.appearance
		}
		set {
			
			self.session.appearance = newValue
		}
	}
}

// MARK: - SessionDelegate
extension PayButton: SessionDelegate {
	
	public func sessionIsStarting(_ session: SessionProtocol) {

		self.uiElement?.startLoader()
	}

	public func sessionCancelled(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
	}

	public func sessionHasStarted(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
	}

	public func sessionHasFailedToStart(_ session: SessionProtocol) {

		self.uiElement?.stopLoader()
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
