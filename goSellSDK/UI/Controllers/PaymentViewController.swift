//
//  PaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   TapAdditionsKit.TypeAlias
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UINavigationController.UINavigationController
import protocol UIKit.UINavigationController.UINavigationControllerDelegate
import enum     UIKit.UINavigationController.UINavigationControllerOperation
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerInteractiveTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// Payment View Controller.
internal class PaymentViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
	// MARK: Properties
	
	internal weak var payButton: (PayButtonProtocol & UIView)?
	
    // MARK: Methods
    
    internal override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !self.hasShownPaymentController {
            
            self.showPaymentController()
        }
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
		
		if let resizableContainerController = segue.destination as? ResizablePaymentContainerViewController {
			
			resizableContainerController.transitioningDelegate = self.animationsHandler
		}
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var blurView: TapVisualEffectView? {
        
        didSet {
            
            self.blurView?.style = .none
        }
    }

    private var hasShownPaymentController = false
    
    private lazy var animationsHandler = TransitionAnimationsHandler()
    
    // MARK: Methods
    
    private func showPaymentController() {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.performSegue(withIdentifier: "\(ResizablePaymentContainerViewController.tap_className)Segue", sender: self)
        }
        
        self.hasShownPaymentController = true
    }
}

// MARK: - TransitionAnimationsHandler
extension PaymentViewController {
    
    private class TransitionAnimationsHandler: NSObject, UIViewControllerTransitioningDelegate {
		
		fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			
			return PaymentPresentationAnimationController()
		}
		
		fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			
			return PaymentDismissalAnimationController()
		}
    }
}
