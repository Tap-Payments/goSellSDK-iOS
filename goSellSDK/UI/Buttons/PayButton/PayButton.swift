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
    
    /// Payment data source.
    @IBOutlet public weak var dataSource: PaymentDataSource? {
        
        didSet {
            
            self.ui?.paymentDataSource = self.dataSource
        }
    }
    
    /// Payment delegate.
    @IBOutlet public weak var delegate: PaymentDelegate? {
     
        didSet {
            
            self.ui?.paymentDelegate = self.delegate
        }
    }
    
    /// Bundle to load nib from.
    public override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    // MARK: Methods
    
    /// Updates displayed amount.
    public func updateDisplayedAmount() {
        
        self.calculateDisplayedAmount()
    }
	
	public override func didMoveToSuperview() {
		
		super.didMoveToSuperview()
		
		if self.superview != nil {
			
			self.updateLayoutDirectionIfRequired()
			self.startMonitoringLayoutDirectionChanges()
		}
	}
	
	public override func willMove(toSuperview newSuperview: UIView?) {
		
		super.willMove(toSuperview: newSuperview)
		
		if newSuperview == nil {
			
			self.stopMonitoringLayoutDirectionChanges()
		}
	}
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var ui: PayButtonUI? {
        
        didSet {
            
            self.ui?.delegate = self
            self.ui?.paymentDataSource = self.dataSource
        }
    }
}

// MARK: - TapButtonDelegate
extension PayButton: TapButtonDelegate {
    
    internal func securityButtonTouchUpInside() {
        
        self.buttonTouchUpInside()
    }
}

// MARK: - PayButtonInternalImplementation
extension PayButton: PayButtonInternalImplementation {
    
    internal var uiElement: PayButtonUI? {
        
        return self.ui
    }
    
    internal func updateDisplayedStateAndAmount() {
        
        self.updateDisplayedAmount()
    }
}

// MARK: - LayoutDirectionObserver
extension PayButton: LayoutDirectionObserver {
	
	internal var viewToUpdateLayoutDirection: UIView {
		
		return self
	}
}
