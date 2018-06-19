//
//  LoadingViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import class    TapGLKit.TapActivityIndicatorView
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

internal final class LoadingViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func show(with text: String? = nil, frame: CGRect = UIScreen.main.bounds) -> LoadingViewController {
        
        let controller = self.instantiate()
        controller.text = text
        
        controller.showOnSeparateWindow { [unowned controller] (rootController) in
            
            rootController.view.window?.frame = frame
            
            rootController.present(controller, animated: true, completion: nil)
            
            NSLog("delegate: \(String(describing: controller.transitioningDelegate))")
        }
        
        return controller
    }
    
    internal func hide() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.dismissFromSeparateWindow(true, completion: nil)
        }
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.descriptionLabel?.text = self.text
    }
    
    // MARK: - Fileprivate -
    
    fileprivate final class Transitioning: NSObject {
        
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
            
            self.loader?.usesCustomColors   = true
            self.loader?.outterCircleColor  = .hex("535353")
            self.loader?.innerCircleColor   = .hex("535353")
            self.loader?.startAnimating()
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel?
    
    private var text: String?
    
    // MARK: Methods
    
    private static func instantiate() -> LoadingViewController {
        
        guard let result = UIStoryboard.goSellSDKPayment.instantiateViewController(withIdentifier: self.className) as? LoadingViewController else {
            
            fatalError("Failed to load \(self.className) from storyboard.")
        }
        
        result.modalPresentationStyle = .custom
        result.transitioningDelegate = Transitioning.shared
        
        return result
    }
}

// MARK: - Singleton
extension LoadingViewController.Transitioning: Singleton {
    
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
        
        return FadeAnimationController(operation: .presentation)
    }
    
    fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeAnimationController(operation: .dismissal)
    }
}
