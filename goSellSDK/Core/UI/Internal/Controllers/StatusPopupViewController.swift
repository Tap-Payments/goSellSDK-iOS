//
//  StatusPopupViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    TapAdditionsKitV2.SeparateWindowRootViewController
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UIButton.UIButton
import class    UIKit.UIImage.UIImage
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// Status Popup View Controller.
internal final class StatusPopupViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal var success: Bool = false {
		
		didSet {
			
			self.updateIconImage()
		}
	}
    
    internal var titleText: String? {
        
        didSet {
            
            self.updateTitleText()
        }
    }
    
    internal var subtitleText: String? {
        
        didSet {
            
            self.updateSubtitleText()
        }
    }
    
    internal var idleDisappearanceTimeInterval: TimeInterval = 5.0 {
        
        didSet {
            
            self.rescheduleAutomaticDisappearance()
        }
    }
    
    // MARK: Methods
    
    internal func display(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.showExternally(completion: completion)
    }
    
    internal override func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.cancelPreviousDismissalRequest()
        super.hide(animated: animated, async: async, completion: completion)
    }
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		
		let theme = Theme.current.statusPopupStyle
		
		self.titleLabel?.setTextStyle(theme.titleStyle)
		self.subtitleLabel?.setTextStyle(theme.subtitleStyle)
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		let theme = Theme.current.statusPopupStyle
		
		self.titleLabel?.setTextStyle(theme.titleStyle)
		self.subtitleLabel?.setTextStyle(theme.subtitleStyle)
		
		self.updateIconImage()
	}
	
    deinit {
        
        self.transitioning = nil
    }
    
    // MARK: - Private -
    
    /// Transitions handler for Status Popup View Controller.
    private final class Transitioning: NSObject, UIViewControllerTransitioningDelegate {
        
        fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            return PopupAnimationController(operation: .presentation)
        }
        
        fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            return PopupAnimationController(operation: .dismissal)
        }
    }
    
    private struct Constants {
        
        fileprivate static let contentHeight: CGFloat = 65.0
        fileprivate static let closeButtonImage: UIImage = .tap_named("ic_close", in: .goSellSDKResources)!
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconImageView: UIImageView? {
        
        didSet {
            
            self.updateIconImage()
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel? {
        
        didSet {
            
            self.updateTitleText()
        }
    }
    
    @IBOutlet private weak var subtitleLabel: UILabel? {
        
        didSet {
            
            self.updateSubtitleText()
        }
    }
    
    @IBOutlet private weak var closeButton: UIButton? {
        
        didSet {
            
            self.closeButton?.setImage(Constants.closeButtonImage, for: .normal)
        }
    }
    
    private static var storage: StatusPopupViewController?
    
    private lazy var transitioning: Transitioning? = Transitioning()
    
    // MARK: Methods
    
    private func updateIconImage() {
		
		let theme = Theme.current.statusPopupStyle
		
		self.iconImageView?.image = self.success ? theme.successImage : theme.failureImage
    }
    
    private func updateTitleText() {
        
        self.titleLabel?.text = self.titleText
    }
    
    private func updateSubtitleText() {
        
        self.subtitleLabel?.text = self.subtitleText
    }
    
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        
        self.hide()
    }
    
    private func rescheduleAutomaticDisappearance() {
        
        self.cancelPreviousDismissalRequest()
        self.perform(#selector(hideWithDefaultParameters), with: nil, afterDelay: self.idleDisappearanceTimeInterval)
    }
    
    private func cancelPreviousDismissalRequest() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideWithDefaultParameters), object: nil)
    }
    
    @objc private func hideWithDefaultParameters() {
        
        self.hide()
    }
}

// MARK: - InstantiatableFromStoryboard
extension StatusPopupViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPopups
    }
}

// MARK: - Singleton
extension StatusPopupViewController: Singleton {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static var shared: StatusPopupViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = StatusPopupViewController.instantiate()
        instance.modalPresentationStyle = .custom
        instance.transitioningDelegate = instance.transitioning
        
        self.storage = instance
        
        return instance
    }
    
    internal static func destroyInstance() { }
}
