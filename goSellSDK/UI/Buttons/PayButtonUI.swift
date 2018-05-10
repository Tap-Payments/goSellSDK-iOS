//
//  PayButtonUI.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNibView.TapNibView
import class TapGLKit.TapActivityIndicatorView
import class UIKit.UIButton.UIButton
import class UIKit.UIView

internal class PayButtonUI: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payment data source.
    internal weak var dataSource: PaymentDataSource?
    
    /// Delegate.
    internal weak var delegate: PayButtonUIDelegate?
    
    internal var isEnabled: Bool = true {
        
        didSet {
            
            self.internalButton?.isEnabled = self.isEnabled
            self.updateAlpha()
        }
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    // MARK: Methods
    
    internal func startLoader() {
        
        self.loader?.startAnimating()
    }
    
    internal func stopLoader(waitUntilFinish: Bool = true) {
        
        if waitUntilFinish {
            
            self.loader?.stopAnimatingWhenFull()
        }
        else {
            
            self.loader?.stopAnimating()
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var loader: TapActivityIndicatorView? {
        
        didSet {
            
            self.loader?.startingProgress = 0.0
        }
    }
    
    @IBOutlet private weak var internalButton: UIButton? {
        
        didSet {
            
            self.internalButton?.isEnabled = self.isEnabled
        }
    }
    
    @IBOutlet private weak var securityButton: UIButton?
    
    @IBOutlet private weak var internalButtonContainerView: UIView? {
        
        didSet {
            
            self.updateAlpha()
        }
    }
    
    // MARK: Methods
    
    @IBAction private func internalButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.payButtonTouchUpInside()
    }
    
    @IBAction private func securityButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.securityButtonTouchUpInside()
    }
    
    private func updateAlpha() {
        
        self.internalButtonContainerView?.alpha = self.isEnabled ? 1.0 : 0.5
    }
}
