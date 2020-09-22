//
//  LoadingViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    TapAdditionsKitV2.SeparateWindowRootViewController
import struct   TapAdditionsKitV2.TypeAlias
import class    TapGLKitV2.TapActivityIndicatorView
import class    TapVisualEffectViewV2.TapVisualEffectView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboard.UIStoryboard
import class	UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// View controller that is showing loading process.
internal final class LoadingViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func show(with text: String? = nil, topOffset: CGFloat = 0.0) -> LoadingViewController {
        
        let controller = self.createAndSetupController()
        controller.text = text
        
        controller.showExternally(userInteractionEnabled: false, topOffset: topOffset)
        
        return controller
    }
    
    internal func hide(animated: Bool, async: Bool, fromDestroyInstance: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        super.hide(animated: animated, async: async) {
            
            if fromDestroyInstance {
                
                completion?()
            }
            else {
                
                let selfType = type(of: self)
                if selfType.storage != nil {
                    
                    selfType.destroyInstance(completion)
                }
            }
        }
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.descriptionLabel?.text = self.text
    }
    
    deinit {
        
        self.transitioning = nil
    }
    
    // MARK: - Fileprivate -
    
    /// Loading view controller transitioning handler.
    private final class Transitioning: NSObject, UIViewControllerTransitioningDelegate {
        
        fileprivate var shouldUseFadeAnimation: Bool = true
        
        fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            return self.shouldUseFadeAnimation ? FadeAnimationController(operation: .presentation) : PaymentPresentationAnimationController(animateBlur: false)
        }
        
        fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            return self.shouldUseFadeAnimation ? FadeAnimationController(operation: .dismissal) : PaymentDismissalAnimationController(animateBlur: false)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var backgroundBlurView: TapVisualEffectView? {
        
        didSet {
            
            self.backgroundBlurView?.style = .light
        }
    }
    
    @IBOutlet private weak var loader: TapActivityIndicatorView? {
        
        didSet {
            
            self.loader?.animationDuration  = Theme.current.commonStyle.loaderAnimationDuration
            self.loader?.usesCustomColors   = true
            self.loader?.outterCircleColor  = .tap_hex("535353")
            self.loader?.innerCircleColor   = .tap_hex("535353")
            self.loader?.startAnimating()
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel?
        
    private var text: String?
    
    private static var storage: LoadingViewController?
    
    private lazy var transitioning: Transitioning? = Transitioning()
    
    // MARK: Methods
    
    private static func createAndSetupController() -> LoadingViewController {
        
        KnownStaticallyDestroyableTypes.add(LoadingViewController.self)
        
        let controller = self.shared
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = controller.transitioning
        
        return controller
    }
}

// MARK: - InstantiatableFromStoryboard
extension LoadingViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPopups
    }
}

// MARK: - DelayedDestroyable
extension LoadingViewController: DelayedDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.storage?.transitioning?.shouldUseFadeAnimation = true
        
        self.storage?.hide(animated: true, async: true, fromDestroyInstance: true) {
            
            self.storage = nil
            KnownStaticallyDestroyableTypes.delayedDestroyableInstanceDestroyed()
            completion?()
        }
    }
}

// MARK: - Singleton
extension LoadingViewController: Singleton {
    
    internal static var shared: LoadingViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = LoadingViewController.instantiate()
        instance.transitioning?.shouldUseFadeAnimation = true
        self.storage = instance
        
        return instance
    }
}

// MARK: - LoadingViewSupport
extension LoadingViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.view
	}
}
