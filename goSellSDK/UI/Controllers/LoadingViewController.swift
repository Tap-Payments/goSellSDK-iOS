//
//  LoadingViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import class    TapAdditionsKit.SeparateWindowRootViewController
import struct   TapAdditionsKit.TypeAlias
import class    TapGLKit.TapActivityIndicatorView
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// View controller that is showing loading process.
internal final class LoadingViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func show(with text: String? = nil, in frame: CGRect = UIScreen.main.bounds) -> LoadingViewController {
        
        let controller = self.createAndSetupController()
        
        controller.text = text
        
        let parentControllerSetupClosure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController> = { (rootController) in
            
            rootController.view.window?.frame = frame
        }
        
        controller.show(userInteractionEnabled: false, parentControllerSetupClosure: parentControllerSetupClosure)
        
        return controller
    }

    internal override func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        super.hide(animated: animated, async: async) {
            
            LoadingViewController.destroyInstance()
            completion?()
        }
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.descriptionLabel?.text = self.text
    }
    
    // MARK: - Fileprivate -
    
    /// Loading view controller transitioning handler.
    fileprivate final class Transitioning: NSObject {
        
        fileprivate var shouldUseFadeAnimation = true
        fileprivate static var storage: Transitioning?
        
        private override init() {
            
            super.init()
            KnownSingletonTypes.add(Transitioning.self)
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
            
            self.loader?.animationDuration  = Theme.current.settings.loaderAnimationDuration
            self.loader?.usesCustomColors   = true
            self.loader?.outterCircleColor  = .hex("535353")
            self.loader?.innerCircleColor   = .hex("535353")
            self.loader?.startAnimating()
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel?
    
    private var text: String?
    
    private static var storage: LoadingViewController?
    
    // MARK: Methods
    
    private static func createAndSetupController() -> LoadingViewController {
        
        KnownSingletonTypes.add(LoadingViewController.self)
        
        let controller = self.shared
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = Transitioning.shared
        
        return controller
    }
}

// MARK: - InstantiatableFromStoryboard
extension LoadingViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPopups
    }
}

// MARK: - Singleton
extension LoadingViewController: Singleton {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static var shared: LoadingViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = LoadingViewController.instantiate()
        self.storage = instance
        
        Transitioning.shared.shouldUseFadeAnimation = true
        
        return instance
    }
    
    internal static func destroyInstance() {
        
        Transitioning.shared.shouldUseFadeAnimation = false
        self.storage?.hide(animated: true)
        self.storage = nil
    }
}

// MARK: - Singleton
extension LoadingViewController.Transitioning: Singleton {
    
    fileprivate static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    fileprivate static var shared: LoadingViewController.Transitioning {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = LoadingViewController.Transitioning()
        self.storage = instance
        
        return instance
    }
    
    fileprivate static func destroyInstance() {
        
        self.storage = nil
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension LoadingViewController.Transitioning: UIViewControllerTransitioningDelegate {
    
    fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.shouldUseFadeAnimation ? FadeAnimationController(operation: .presentation) : PaymentPresentationAnimationController(animateBlur: false)
    }
    
    fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.shouldUseFadeAnimation ? FadeAnimationController(operation: .dismissal) : PaymentDismissalAnimationController(animateBlur: false)
    }
}
