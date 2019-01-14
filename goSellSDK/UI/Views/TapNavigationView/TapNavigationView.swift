//
//  TapNavigationView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGSize
import struct TapAdditionsKit.TypeAlias
import class TapNibView.TapNibView
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIButton.UIButton
import class UIKit.UIImage.UIImage
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UIView.UIView

/// Tap Navigation View
internal final class TapNavigationView: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate
    internal weak var delegate: TapNavigationViewDelegate?
    
    /// Icon image.
    internal var iconImage: UIImage? {
        
        get {
            
            return self.iconImageView?.image
        }
        set {
            
            self.iconImageView?.image = newValue
            self.updateIconLayout()
        }
    }
    
    /// Title.
    internal var title: String? {
        
        get {
            
            return self.titleLabel?.text
        }
        set {
            
            self.titleLabel?.text = newValue
        }
    }
    
    /// Custom right view.
    internal var customRightView: UIView? {
        
        get {
            
            return self.rightViewHolder?.subviews.first
        }
        set {
            
            guard let nonnullHolder = self.rightViewHolder else { return }
            
            while nonnullHolder.subviews.count > 0 {
                
                nonnullHolder.subviews.last?.removeFromSuperview()
            }
            
            if let newRightView = newValue {
                
                nonnullHolder.addSubviewWithConstraints(newRightView)
            }
            
            self.updateRightViewLayout()
        }
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal override var intrinsicContentSize: CGSize {
        
        let screen = self.window?.screen ?? UIScreen.main
        return CGSize(width: screen.bounds.width, height: Constants.height)
    }
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
        self.updateRightViewLayout()
        self.updateIconLayout()
    }
    
    internal override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return self.intrinsicContentSize
    }
    
    internal override func layoutSubviews() {
        
        super.layoutSubviews()
        self.updateIconLayout()
        self.updateRightViewLayout()
    }
	
	internal func setStyle(_ style: NavigationBarStyle) {
		
		self.backButton?.setImage(style.backIcon, for: .normal)
		self.titleLabel?.setTextStyle(style.titleStyle)
	}
	
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let height: CGFloat = 66.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var backButton: UIButton?
    
    @IBOutlet private weak var iconImageView: UIImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var rightViewHolder: UIView?
    @IBOutlet private var constraintsToDeactivateWhenRightViewAvailable: [NSLayoutConstraint]?
    
    @IBOutlet private weak var iconViewHolder: UIView?
    @IBOutlet private var constraintsToDeactivateWhenIconAvailable: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToActivateWhenIconAvailable: [NSLayoutConstraint]?
    
    // MARK: Methods
    
    private func updateIconLayout() {
        
        guard
            
            let nonnullSuccessConstraints = self.constraintsToActivateWhenIconAvailable,
            let nonnullFailureConstraints = self.constraintsToDeactivateWhenIconAvailable
        
        else { return }
        
        let iconVisible = self.iconImageView?.image != nil
        
        let additionalAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.rightViewHolder?.isHidden = !iconVisible
        }
        
        NSLayoutConstraint.reactivate(inCaseIf: iconVisible,
                                      constraintsToDisableOnSuccess: nonnullFailureConstraints,
                                      constraintsToEnableOnSuccess: nonnullSuccessConstraints,
                                      viewToLayout: self,
                                      animationDuration: 0.0,
                                      additionalAnimations: additionalAnimation)
        
        if let nonnullImage = self.iconImageView?.image, let size = self.iconImageView?.bounds.size {
            
            self.iconImageView?.contentMode = nonnullImage.bestContentMode(toFit: size)
        }
    }
    
    private func updateRightViewLayout() {
        
        guard let constraintsToDisableIfRightViewAvailable = self.constraintsToDeactivateWhenRightViewAvailable else { return }
        
        let rightViewAvailable = (self.rightViewHolder?.subviews.count ?? 0) > 0
        
        let additionalAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.rightViewHolder?.isHidden = !rightViewAvailable
        }
        
        NSLayoutConstraint.reactivate(inCaseIf: rightViewAvailable,
                                      constraintsToDisableOnSuccess: constraintsToDisableIfRightViewAvailable,
                                      constraintsToEnableOnSuccess: [],
                                      viewToLayout: self,
                                      animationDuration: 0.0,
                                      additionalAnimations: additionalAnimation)
    }
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.navigationViewBackButtonClicked(self)
    }
}

// MARK: - SingleLocalizable
extension TapNavigationView: SingleLocalizable {
	
	internal func setLocalized(text: String?) {
		
		self.title = text
	}
}
