//
//  TapButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    TapGLKit.TapActivityIndicatorView
import class    TapNibView.TapNibView
import func     TapSwiftFixes.performOnMainThread
import class    UIKit.UIButton.UIButton
import class    UIKit.UIView.UIView

internal class TapButton: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate.
    internal weak var delegate: TapButtonDelegate?
    
    /// Defines if the receiver is enabled.
    internal var isEnabled: Bool = true {
        
        didSet {
            
            self.updateStateUI(animated: true)
        }
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal var themeSettings: TapButtonSettings = Theme.current.settings.payButtonSettings {
        
        didSet {
            
            self.updateTheme(animated: true)
        }
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
    
    internal override func setup() {
        
        super.setup()
        
        self.cornerRadius = 0.5 * min(self.bounds.width, self.bounds.height)
        self.updateTheme(animated: false)
    }
    
    internal func setTitle(_ title: String) {
        
        self.internalButton?.setTitle(title, for: .normal)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let stateUpdateAnimationDuration: TimeInterval = 0.2
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var loader: TapActivityIndicatorView? {
        
        didSet {
            
            self.loader?.animationDuration = Theme.current.settings.loaderAnimationDuration
            self.loader?.startingProgress = 0.0
        }
    }
    
    @IBOutlet private weak var internalButton: UIButton? {
        
        didSet {
            
            self.internalButton?.isEnabled = self.isEnabled
        }
    }
    
    @IBOutlet private weak var securityButton: UIButton?
    
    private var isHighlighted = false
    
    // MARK: Methods
    
    @IBAction private func internalButtonHighlighted(_ sender: Any) {
        
        self.isHighlighted = self.delegate?.canBeHighlighted ?? true
        self.updateTheme(animated: true)
    }
    
    @IBAction private func internalButtonLostHighlight(_ sender: Any) {
        
        self.isHighlighted = false
        self.updateTheme(animated: true)
    }
    
    @IBAction private func internalButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.buttonTouchUpInside()
    }
    
    @IBAction private func securityButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.securityButtonTouchUpInside()
    }
    
    private func updateStateUI(animated: Bool) {
        
        self.internalButton?.isEnabled = self.isEnabled
        self.updateTheme(animated: animated)
    }
    
    private func updateTheme(animated: Bool) {
        
        performOnMainThread {
            
            let updates: TypeAlias.ArgumentlessClosure = { [weak self] in
                
                guard let strongSelf = self else { return }
                
                let settings = strongSelf.themeSettings
                let stateSettings = strongSelf.isEnabled ? (strongSelf.isHighlighted ? settings.highlighted : settings.enabled) : settings.disabled
                
                strongSelf.layer.backgroundColor = stateSettings.backgroundColor.cgColor
                
                strongSelf.loader?.usesCustomColors = true
                strongSelf.loader?.outterCircleColor = stateSettings.loaderColor
                strongSelf.loader?.innerCircleColor = stateSettings.loaderColor
                
                strongSelf.internalButton?.titleLabel?.font = stateSettings.textFont
                strongSelf.internalButton?.setTitleColor(stateSettings.textColor, for: strongSelf.isHighlighted ? .highlighted : .normal)
                
                strongSelf.securityButton?.setImage(stateSettings.securityIcon, for: strongSelf.isHighlighted ? .highlighted : .normal)
            }
            
            let duration = animated ? Constants.stateUpdateAnimationDuration : 0.0
            UIView.animate(withDuration: duration, animations: updates)
        }
    }
}
