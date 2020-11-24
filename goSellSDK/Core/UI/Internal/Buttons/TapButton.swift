//
//  TapButton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKitV2.TypeAlias
import class    TapGLKitV2.TapActivityIndicatorView
import class    TapNibViewV2.TapNibView
import func     TapSwiftFixesV2.performOnMainThread
import class    UIKit.UIButton.UIButton
import class    UIKit.UIView.UIView

internal class TapButton: TapNibView {
    
    // MARK: - Internal -
	
	internal typealias Delegate = TapButtonDelegate
	
    // MARK: Properties
    
    /// Delegate.
    internal weak var delegate: Delegate?
    
    /// Defines if the receiver is enabled.
    internal var isEnabled: Bool = true {
        
        didSet {
            
            self.updateStateUI(animated: true)
        }
    }
    
    /// Defines if the receiver is force disabled.
    internal var forceDisabled: Bool = false {
        
        didSet {
            
            self.updateStateUI(animated: true)
        }
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
	internal var themeStyle: TapButtonStyle = Theme.current.buttonStyles.first! {
        
        didSet {
            
            self.updateTheme(animated: true)
        }
    }
	
	internal private(set) var isHighlighted = false
    
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
        
        self.tap_cornerRadius = 0.5 * min(self.bounds.width, self.bounds.height)
        self.updateTheme(animated: false)
    }
    
    internal func setTitle(_ title: String?) {
		
		self.internalButton?.tap_title = title
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let stateUpdateAnimationDuration: TimeInterval = 0.2
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var loader: TapActivityIndicatorView? {
        
        didSet {
			
			self.loader?.animationDuration = Theme.current.commonStyle.loaderAnimationDuration
            self.loader?.startingProgress = 0.0
        }
    }
    
    @IBOutlet private weak var internalButton: UIButton? {
        
        didSet {
            
            self.internalButton?.isEnabled = self.isEnabled
        }
    }
    
	@IBOutlet private weak var securityButton: UIButton? {
		
		didSet {
			
			self.securityButton?.contentMode = .center
			self.securityButton?.imageView?.contentMode = .center
		}
	}
	
	@IBOutlet private weak var internalDisabledButton: UIButton? {
		
		didSet {
			
			self.internalDisabledButton?.isEnabled = !self.isEnabled
		}
	}
	
	@IBOutlet private weak var loaderContainerView: UIView?
	@IBOutlet private weak var securityButtonContainerView: UIView?
    
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
	
	@IBAction private func internalDisabledButtonTouchUpInside(_ sender: Any) {
		
		self.delegate?.disabledButtonTouchUpInside()
	}
	
    private func updateStateUI(animated: Bool) {
        
        let enabled = self.isEnabled && !self.forceDisabled
        self.internalButton?.isEnabled = enabled
        self.securityButton?.isUserInteractionEnabled = enabled
		self.internalDisabledButton?.isEnabled = !enabled
		self.updateTheme(animated: animated)
	}
	
	private func updateTheme(animated: Bool) {
		
		let updates: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			guard let strongSelf = self else { return }
			
			let enabled = strongSelf.isEnabled && !strongSelf.forceDisabled
			
			let settings = strongSelf.themeStyle
			let stateSettings = enabled ? (strongSelf.isHighlighted ? settings.highlighted : settings.enabled) : settings.disabled
			
			strongSelf.tap_cornerRadius = stateSettings.cornerRadius
			strongSelf.layer.backgroundColor = stateSettings.backgroundColor.color.cgColor
			
			strongSelf.loaderContainerView?.alpha = stateSettings.isLoaderVisible ? 1.0 : 0.0
			strongSelf.loader?.usesCustomColors = true
			strongSelf.loader?.outterCircleColor = stateSettings.loaderColor.color
			strongSelf.loader?.innerCircleColor = stateSettings.loaderColor.color
			
			strongSelf.securityButtonContainerView?.alpha = stateSettings.isSecurityIconVisible ? 1.0 : 0.0
			strongSelf.securityButton?.setImage(stateSettings.securityIcon, for: strongSelf.isHighlighted ? .highlighted : .normal)
			
			strongSelf.internalButton?.setTitleStyle(stateSettings.titleStyle)
            
            strongSelf.loader?.isHidden = !stateSettings.isLoaderVisible || settings.type == .async
            strongSelf.securityButton?.isHidden = !stateSettings.isSecurityIconVisible || settings.type == .async
		}
		
		let duration = animated ? Constants.stateUpdateAnimationDuration : 0.0
		UIView.animate(withDuration: duration, animations: updates)
	}
}

// MARK: - Localizable
extension TapButton: SingleLocalizable {
	
    internal func setLocalized(text: String?) {
        
        self.setTitle(text)
    }
}
