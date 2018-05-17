//
//  TapNavigationView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGSize
import class TapNibView.TapNibView
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIButton.UIButton
import class UIKit.UIImage.UIImage
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UIView.UIView

/// Tap Navigation View
internal class TapNavigationView: TapNibView {
    
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
            self.updateLayout()
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
    
    internal override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return self.intrinsicContentSize
    }
    
    internal override func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        if self.superview != nil {
            
            self.updateLayout()
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let height: CGFloat = 66.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var backButton: UIButton? {
        
        didSet {
            
            self.backButton?.setImage(Theme.current.settings.generalImages.arrowLeft, for: .normal)
        }
    }
    
    @IBOutlet private weak var iconImageView: UIImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var rightViewHolder: UIView?
    
    @IBOutlet private var iconHolderWidthConstraintWhenIconAvailable: NSLayoutConstraint?
    @IBOutlet private var iconHolderWidthConstraintWhenIconUnavailable: NSLayoutConstraint?
    
    // MARK: Methods
    
    private func updateLayout() {
        
        guard
            
            let nonnullSuccessConstraint = self.iconHolderWidthConstraintWhenIconAvailable,
            let nonnullFailureConstraint = self.iconHolderWidthConstraintWhenIconUnavailable
        
        else { return }
        
        let iconVisible = self.iconImageView?.image != nil
        
        NSLayoutConstraint.reactivate(inCaseIf: iconVisible,
                                      constraintsToDisableOnSuccess: [nonnullFailureConstraint],
                                      constraintsToEnableOnSuccess: [nonnullSuccessConstraint],
                                      viewToLayout: self,
                                      animationDuration: 0.0)
    }
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.navigationViewBackButtonClicked(self)
    }
}
