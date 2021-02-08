//
//  TapNavigationView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct	TapAdditionsKitV2.TypeAlias
import class	TapNetworkManagerV2.TapImageLoader
import class	TapNibViewV2.TapNibView
import class	UIKit.NSLayoutConstraint.NSLayoutConstraint
import class	UIKit.UIButton.UIButton
import class	UIKit.UIImage.UIImage
import class	UIKit.UIImageView.UIImageView
import class	UIKit.UILabel.UILabel
import class	UIKit.UIScreen.UIScreen
import class	UIKit.UIView.UIView

/// Tap Navigation View
internal final class TapNavigationView: TapNibView {
    
    // MARK: - Internal -
	
	internal typealias DataSource	= TapNavigationViewDataSource
	internal typealias Delegate		= TapNavigationViewDelegate
	
    // MARK: Properties
	
	internal static let preferredHeight = Constants.height
	
	/// Data source.
	internal weak var dataSource: DataSource? {
		
		didSet {
			
			if !self.skipsUpdateOnDatasourceChange {
				
				self.updateContentAndLayout(animated: false)
			}
		}
	}
	
    /// Delegate
    internal weak var delegate: Delegate?
	
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal override var intrinsicContentSize: CGSize {
        
        let screen = self.window?.screen ?? UIScreen.main
		return CGSize(width: screen.bounds.width, height: type(of: self).preferredHeight)
    }
	
	internal var backgroundOpacity: CGFloat {
		
		get {
			
			return self.backgroundView?.alpha ?? 0.0
		}
		set {
			
			self.backgroundView?.alpha = newValue
		}
	}
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
		self.updateContentAndLayout(animated: false)
    }
	
	internal override func didMoveToWindow() {
		
		super.didMoveToWindow()
		
		guard self.window != nil else { return }
		
		DispatchQueue.main.async { [weak self] in
			
			self?.updateLayout(animated: false)
		}
	}
	
    internal override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return self.intrinsicContentSize
    }
	
	internal func setStyle(_ style: NavigationBarStyle) {
		
		self.backgroundView?.backgroundColor = style.backgroundColor.color
		self.backButton?.setImage(style.backIcon, for: .normal)
		self.titleLabel?.setTextStyle(style.titleStyle)
		
		if let iconStyle = style.iconStyle {
			
			self.iconImageView?.tap_cornerRadius = iconStyle.cornerRadius
		}
		
		self.closeButton?.titleLabel?.font = style.cancelNormalStyle.font.localized
		self.closeButton?.setTitleColor(style.cancelNormalStyle.color.color, for: .normal)
		self.closeButton?.setTitleColor(style.cancelHighlightedStyle.color.color, for: .highlighted)
		self.closeButton?.setLocalizedText(.common_cancel)
		self.closeButton?.tap_title = self.closeButton?.tap_title?.uppercased()
	}
	
	internal func setDataSource(_ datasource: DataSource?, animated: Bool) {
		
		self.skipsUpdateOnDatasourceChange = true
		self.dataSource = datasource
		self.skipsUpdateOnDatasourceChange = false
		
		self.updateContentAndLayout(animated: animated)
	}
	
	internal func updateContentAndLayout(animated: Bool) {
		
		guard self.dataSource != nil else { return }
		
		self.updateContent(animated: animated)
		self.updateLayout(animated: animated)
	}
	
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let height: CGFloat = 66.0
		fileprivate static let animationDuration: TimeInterval = 0.3
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
	
	@IBOutlet private weak	var backgroundView: UIView?
	
	@IBOutlet internal weak	var backButtonContainerView: UIView?
    @IBOutlet private weak	var backButton: UIButton?
	@IBOutlet private		var constraintsToDeactivateWhenBackButtonIsAvailable: [NSLayoutConstraint]?
	@IBOutlet private		var constraintsToActivateWhenBackButtonIsAvailable: [NSLayoutConstraint]?
	
	@IBOutlet weak	var closeButtonContainerView: UIView?
	@IBOutlet private weak	var closeButton: UIButton?
	@IBOutlet private		var constraintsToDeactivateWhenCloseButtonIsAvailable: [NSLayoutConstraint]?
	@IBOutlet private		var constraintsToActivateWhenCloseButtonIsAvailable: [NSLayoutConstraint]?
	
	@IBOutlet private weak	var iconContainerView: UIView?
    @IBOutlet private weak	var iconImageView: UIImageView?
	@IBOutlet private		var constraintsToDeactivateWhenIconIsAvailable: [NSLayoutConstraint]?
	@IBOutlet private		var constraintsToActivateWhenIconIsAvailable: [NSLayoutConstraint]?
	
    @IBOutlet private weak var titleLabel: UILabel?
	
	private var isBackButtonVisible: Bool {
		
		return self.dataSource?.navigationViewCanGoBack(self) ?? false
	}
	
	private var skipsUpdateOnDatasourceChange = false
	
	private var appliedIcon: Image?
	private var hasIcon: Bool = false
	
    // MARK: Methods
	
	private func updateLayout(animated: Bool) {
		
		let animationDuration = animated ? Constants.animationDuration : 0.0
		
		let animations: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.updateIconLayout			(with: animationDuration, false)
			self?.updateBackButtonLayout	(with: animationDuration, false)
			self?.updateCloseButtonLayout	(with: animationDuration, false)
			
			self?.tap_layout()
		}
		
		if animated {
			
			UIView.animate(withDuration:	animationDuration,
						   delay:			0.0,
						   options:			[.beginFromCurrentState, .curveEaseInOut],
						   animations:		animations,
						   completion:		nil)
		}
		else {
			
			UIView.performWithoutAnimation(animations)
		}
	}
	
	private func updateIconLayout(with duration: TimeInterval = 0.0, _ layout: Bool = true) {
        
        guard
            
            let nonnullSuccessConstraints = self.constraintsToActivateWhenIconIsAvailable,
            let nonnullFailureConstraints = self.constraintsToDeactivateWhenIconIsAvailable
        
        else { return }
        
        let iconVisible = self.hasIcon
		
		let additionalAnimation: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.iconContainerView?.alpha = iconVisible ? 1.0 : 0.0
		}
		
		NSLayoutConstraint.tap_reactivate(inCaseIf:							iconVisible,
										  constraintsToDisableOnSuccess:	nonnullFailureConstraints,
										  constraintsToEnableOnSuccess:		nonnullSuccessConstraints,
										  viewToLayout:						layout ? self : nil,
										  animationDuration:				duration,
										  additionalAnimations:				additionalAnimation)
    }
	
	private func updateBackButtonLayout(with duration: TimeInterval = 0.0, _ layout: Bool = true) {
		
		guard
			
			let nonnullSuccessConstraints = self.constraintsToActivateWhenBackButtonIsAvailable,
			let nonnullFailureConstraints = self.constraintsToDeactivateWhenBackButtonIsAvailable
			
		else { return }
		
		let buttonVisible = self.isBackButtonVisible
		
		let additionalAnimation: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.backButtonContainerView?.alpha = buttonVisible ? 1.0 : 0.0
		}
		
		NSLayoutConstraint.tap_reactivate(inCaseIf:							buttonVisible,
										  constraintsToDisableOnSuccess:	nonnullFailureConstraints,
										  constraintsToEnableOnSuccess:		nonnullSuccessConstraints,
										  viewToLayout:						layout ? self : nil,
										  animationDuration:				duration,
										  additionalAnimations:				additionalAnimation)
	}
	
	private func updateCloseButtonLayout(with duration: TimeInterval = 0.0, _ layout: Bool = true) {
		
		guard
			
			let nonnullSuccessConstraints = self.constraintsToActivateWhenCloseButtonIsAvailable,
			let nonnullFailureConstraints = self.constraintsToDeactivateWhenCloseButtonIsAvailable
			
		else { return }
		
		let buttonVisible = !self.isBackButtonVisible
		
		let additionalAnimation: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.closeButtonContainerView?.alpha = buttonVisible ? 1.0 : 0.0
		}
		
		NSLayoutConstraint.tap_reactivate(inCaseIf:							buttonVisible,
										  constraintsToDisableOnSuccess:	nonnullFailureConstraints,
										  constraintsToEnableOnSuccess:		nonnullSuccessConstraints,
										  viewToLayout:						layout ? self : nil,
										  animationDuration:				duration,
										  additionalAnimations:				additionalAnimation)
	}
	
	private func updateContent(animated: Bool) {
		
		self.updateTitle(animated: animated)
		self.updateIcon(animated: animated)
	}
	
	private func updateTitle(animated: Bool) {
		
		let title = self.dataSource?.navigationViewTitle(for: self) ?? .tap_empty
		self.titleLabel?.tap_setText(title, animationDuration: animated ? Constants.animationDuration : 0.0)
	}
	
	private func updateIcon(animated: Bool) {
		
		guard let icon = self.dataSource?.navigationViewIcon(for: self) else {
			
			self.setIconAndLayout(nil, layout: false, animated: animated)
			return
		}
		
		guard self.appliedIcon != icon else { return }
		
		self.appliedIcon = icon
		
		switch icon {
			
		case .named(let name, let bundle):
			
			let image = UIImage.tap_named(name, in: bundle)
			self.setIconAndLayout(image, layout: false, animated: animated)
			
		case .ready(let image):
			
			self.setIconAndLayout(image, layout: false, animated: animated)
			
		case .remote(let imageURL):
			
			if let placeholder = self.dataSource?.navigationViewIconPlaceholder(for: self) {
				
				switch placeholder {
					
				case .named(let name, let bundle):
					
					let image = UIImage.tap_named(name, in: bundle)
					self.setIconAndLayout(image, layout: false, animated: animated)
					
				case .ready(let image):
					
					self.setIconAndLayout(image, layout: false, animated: animated)
					
				default:
					
					print("Remote placeholders are not supported yet.")
				}
			}
			
			TapImageLoader.shared.downloadImage(from: imageURL) { [weak self] (image, _) in
				
				guard
					
					let strongSelf = self,
					strongSelf.dataSource?.navigationViewIcon(for: strongSelf) == icon
					
				else { return }
				
				strongSelf.setIconAndLayout(image, layout: true, animated: animated)
			}
		}
	}
	
	private func setIconAndLayout(_ image: UIImage?, layout: Bool, animated: Bool) {
		
		self.hasIcon = image != nil
		let animationDuration = animated ? Constants.animationDuration : 0.0
        DispatchQueue.main.async() {
            self.iconImageView?.image = image
            
            if layout {
                
                self.updateIconLayout(with: animationDuration, true)
            }
            
            if let nonnullImage = self.iconImageView?.image, let size = self.iconImageView?.bounds.size {
                
                self.iconImageView?.contentMode = nonnullImage.tap_bestContentMode(toFit: size)
            }
        }
	}
	
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.navigationViewBackButtonClicked(self)
    }
	
	@IBAction private func closeButtonTouchUpInside(_ sender: Any) {
		
		self.delegate?.navigationViewCloseButtonClicked(self)
	}
}
