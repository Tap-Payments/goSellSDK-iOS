//
//  PaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
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
        
        if let paymentController = segue.destination as? PaymentViewController {
            
            paymentController.transitioningDelegate = self
        }
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var payButton: PayButtonProtocol?
    
    // MARK: - Private -
    // MARK: Properties
    
    private var hasShownPaymentController = false
    
    private var payButtonFrame: CGRect = .zero
    
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

// MARK: - UIViewControllerTransitioningDelegate
extension PaymentContainerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PaymentPresentationAnimationController(startFrame: self.payButtonFrame)
    }
}
