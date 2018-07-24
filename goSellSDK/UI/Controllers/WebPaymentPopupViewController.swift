//
//  WebPaymentPopupViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import struct   CoreGraphics.CGGeometry.CGRect
import class    TapAdditionsKit.SeparateWindowRootViewController
import struct   TapAdditionsKit.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

internal final class WebPaymentPopupViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func show(in frame: CGRect, with url: URL) {
        
        let controller = self.createAndSetupController()
        controller.initialURL = url
        
        let parentControllerSetupClosure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController> = { (rootController) in
            
            rootController.view.window?.frame = frame
        }
        
        controller.show(parentControllerSetupClosure: parentControllerSetupClosure)
    }
    
    internal override func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        super.hide(animated: animated, async: async) {
            
            WebPaymentPopupViewController.destroyInstance()
            completion?()
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
        
        KnownSingletonTypes.add(WebPaymentPopupViewController.self)
        
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

// MARK: - Singleton
extension WebPaymentPopupViewController: Singleton {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static var shared: WebPaymentPopupViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = WebPaymentPopupViewController.instantiate()
        instance.transitioning?.shouldUseDefaultWebPopupAnimation = true
        
        self.storage = instance
        
        return instance
    }
    
    internal static func destroyInstance() {
        
        self.storage?.transitioning?.shouldUseDefaultWebPopupAnimation = false
        self.storage?.hide(animated: true)
        self.storage = nil
    }
}

// MARK: - WebPaymentContentViewControllerDelegate
extension WebPaymentPopupViewController: WebPaymentContentViewControllerDelegate {
    
    internal func webPaymentContentViewController(_ controller: WebPaymentContentViewController, webViewDidScroll contentOffset: CGPoint) {
        
        MerchantInformationHeaderViewController.findInHierarchy()?.updateBackgroundOpacityBasedOnScrollContentOverlapping(contentOffset.y)
    }
    
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
