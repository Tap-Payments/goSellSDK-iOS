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
    
    /// Theme of the payment controller. Default is light.
    public var controllerTheme: Theme = .light
    
    /// Payment data source.
    @IBOutlet public weak var dataSource: PaymentDataSource? {
        
        didSet {
            
            self.ui?.dataSource = self.dataSource
        }
    }
    
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
            self.ui?.dataSource = self.dataSource
        }
    }
}

extension PayButton: PayButtonUIDelegate {
    
    internal func securityButtonTouchUpInside() {
        
    }
}

extension PayButton: PayButtonInternalImplementation {
    
    internal var theme: Theme {
        
        return self.controllerTheme
    }
    
    internal var uiElement: PayButtonUI? {
        
        return self.ui
    }
}
