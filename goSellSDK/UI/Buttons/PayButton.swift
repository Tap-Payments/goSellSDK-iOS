//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNibView.TapNibView
import class UIKit.UIButton.UIButton

/// Pay button.
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
    
    /// Theme of the payment controller. Default is light.
    public var controllerTheme: Theme = .light
    
    /// Payment data source.
    @IBOutlet public weak var dataSource: PaymentDataSource? {
        
        didSet {
            
            self.ui?.dataSource = self.dataSource
        }
    }
    
    public override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    // MARK: Methods
    
    public func updateDisplayedStateAndAmount() {
        
        self.ui?.updateDisplayedStateAndAmount()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var ui: PayButtonUI? {
        
        didSet {
            
            self.ui?.delegate = self
            self.ui?.dataSource = self.dataSource
        }
    }
}

// MARK: - PayButtonUIDelegate
extension PayButton: PayButtonUIDelegate {
    
    internal func securityButtonTouchUpInside() {
        
        
    }
}

// MARK: - PayButtonInternalImplementation
extension PayButton: PayButtonInternalImplementation {
    
    internal var theme: Theme {
        
        return self.controllerTheme
    }
    
    internal var uiElement: PayButtonUI? {
        
        return self.ui
    }
}
