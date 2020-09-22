//
//  WebPaymentPopupViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    TapAdditionsKitV2.SeparateWindowRootViewController
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// Web payment view controller popup container.
internal final class WebPaymentPopupViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
	internal static func show(with topOffset: CGFloat, with url: URL, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let controller = self.createAndSetupController()
        controller.initialURL = url
        
		controller.showExternally(topOffset: topOffset, completion: completion)
    }
    
    internal override func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
        super.hide(animated: animated, async: async) {
            
            WebPaymentPopupViewController.destroyInstance()
			ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeWindowedBack {
				
			 	completion?()
			}
        }
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let webPaymentContentController = segue.destination as? WebPaymentContentViewController {
            
            self.contentController = webPaymentContentController
        }
    }
    
    deinit {
        
        self.transitioning = nil
    }
    
    // MARK: - Fileprivate -
    
    /// Transition handler for Web Payment Popup View Controller.
    private final class Transitioning: NSObject, UIViewControllerTransitioningDelegate {
        
        fileprivate var shouldUseDefaultWebPopupAnimation = true
        
        fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            guard let to = presenting as? UIViewController & PopupPresentationSupport else { return nil }
            
            return self.shouldUseDefaultWebPopupAnimation   ? PopupPresentationAnimationController(presentationFrom: presented, to: to)
                : PaymentDismissalAnimationController()
        }
        
        fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            guard let from = dismissed as? UIViewController & PopupPresentationSupport, let to = from.presentingViewController else { return nil }
            
            return self.shouldUseDefaultWebPopupAnimation   ? PopupPresentationAnimationController(dismissalFrom: from, to: to)
                : PaymentDismissalAnimationController()
        }
    }
    
    // MARK: - Private -
    
    @IBOutlet private weak var contentViewTopOffsetConstraint: NSLayoutConstraint?
    
    private static var storage: WebPaymentPopupViewController?
    
    private var initialURL: URL? {
        
        didSet {
            
            self.passURLToContentController()
        }
    }
    
    private weak var contentController: WebPaymentContentViewController? {
        
        didSet {
            
            self.contentController?.delegate = self
            self.passURLToContentController()
        }
    }
    
    private lazy var transitioning: Transitioning? = Transitioning()
    
    // MARK: Methods
    
    private static func createAndSetupController() -> WebPaymentPopupViewController {
        
        KnownStaticallyDestroyableTypes.add(WebPaymentPopupViewController.self)
        
        let controller = self.shared
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = controller.transitioning
        
        return controller
    }
    
    private func passURLToContentController() {
        
        guard let controller = self.contentController, let url = self.initialURL else { return }
        
        controller.setup(with: url)
    }
}

// MARK: - InstantiatableFromStoryboard
extension WebPaymentPopupViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPayment
    }
}

// MARK: - DelayedDestroyable
extension WebPaymentPopupViewController: DelayedDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.storage?.transitioning?.shouldUseDefaultWebPopupAnimation = false
        
        self.storage?.hide(animated: true, async: true) {
            
            self.storage = nil
            KnownStaticallyDestroyableTypes.delayedDestroyableInstanceDestroyed()
            completion?()
        }
    }
}

// MARK: - Singleton
extension WebPaymentPopupViewController: Singleton {
    
    internal static var shared: WebPaymentPopupViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = WebPaymentPopupViewController.instantiate()
        instance.transitioning?.shouldUseDefaultWebPopupAnimation = true
        
        self.storage = instance
        
        return instance
    }
}

// MARK: - WebPaymentContentViewControllerDelegate
extension WebPaymentPopupViewController: WebPaymentContentViewControllerDelegate {
	
    internal func webPaymentContentViewControllerRequestedDismissal(_ controller: WebPaymentContentViewController) {
        
        self.hide()
    }
}

// MARK: - PopupPresentationSupport
extension WebPaymentPopupViewController: PopupPresentationSupport {
    
    internal var presentationAnimationAnimatingConstraint: NSLayoutConstraint? {
        
        return self.contentViewTopOffsetConstraint
    }
    
    internal var viewToLayout: UIView {
        
        return self.view
    }
}

// MARK: - LoadingViewSupport
extension WebPaymentPopupViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.view
	}
}
