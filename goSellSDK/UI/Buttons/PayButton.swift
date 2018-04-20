//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNibView.TapNibView
import class UIKit.UIButton.UIButton

public class PayButton: TapNibView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Defines if the receiver is enabled.
    public var isEnabled: Bool {
        
        get {
            
            return self.ui?.isEnabled ?? false
        }
        set {
            
            self.ui?.isEnabled = newValue
        }
    }
    
    /// State of the receiver.
    public var state: PayButtonState = .enabled
    
    /// Delegate.
    @IBOutlet public weak var delegate: PayButtonDelegate?
    
    public var amount: Decimal = 0.0
    public var currency: String = "KWD"
    
    public override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var ui: PayButtonUI? {
        
        didSet {
            
            self.ui?.delegate = self
        }
    }
}

extension PayButton: PayButtonUIDelegate {
    
    internal func securityButtonTouchUpInside() {
        
    }
}

extension PayButton: PayButtonInternalImplementation {}
