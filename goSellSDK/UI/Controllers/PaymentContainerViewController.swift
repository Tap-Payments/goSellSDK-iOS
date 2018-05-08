//
//  PaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect
import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UINavigationController.UINavigationController
import protocol UIKit.UINavigationController.UINavigationControllerDelegate
import enum UIKit.UINavigationController.UINavigationControllerOperation
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UIView.UIView
import class UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

public class PaymentContainerViewController: UIViewController {
    
    public override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !self.hasShownPaymentController {
            
            self.obtainPayButtonFrame()
            self.showPaymentController()
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let navigationController = segue.destination as? UINavigationController, navigationController.rootViewController is PaymentViewController {
            
            navigationController.delegate = self.animationsHandler
            navigationController.transitioningDelegate = self.animationsHandler
        }
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var payButton: (PayButtonProtocol & UIView)?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var blurView: TapVisualEffectView? {
        
        didSet {
            
            self.blurView?.style = .none
        }
    }
    
    private var hasShownPaymentController = false
    
    private var payButtonFrame: CGRect = .zero
    
    private lazy var animationsHandler = TransitionAnimationsHandler()
    
    // MARK: Methods
    
    private func obtainPayButtonFrame() {
        
        guard let button = self.payButton?.view, let containingView = self.presentingViewController?.view else { return }
        
        self.payButtonFrame = containingView.convert(button.bounds, from: button)
    }
    
    private func showPaymentController() {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.performSegue(withIdentifier: "\(PaymentViewController.className)Segue", sender: self)
        }
        
        self.hasShownPaymentController = true
    }
}

// MARK: - TransitionAnimationsHandler
extension PaymentContainerViewController {
    
    fileprivate class TransitionAnimationsHandler: NSObject {}
}

// MARK: - UIViewControllerTransitioningDelegate
extension PaymentContainerViewController.TransitionAnimationsHandler: UIViewControllerTransitioningDelegate {
    
    fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PaymentPresentationAnimationController()
    }
    
    fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PaymentDismissalAnimationController()
    }
}

// MARK: - UINavigationControllerDelegate
extension PaymentContainerViewController.TransitionAnimationsHandler: UINavigationControllerDelegate {
    
    fileprivate func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return UINavigationControllerSideAnimationController(operation: operation)
    }
}
