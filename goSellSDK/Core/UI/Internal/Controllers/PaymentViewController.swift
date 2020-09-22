//
//  PaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   TapAdditionsKitV2.TypeAlias
import class    TapVisualEffectViewV2.TapVisualEffectView
import class	UIKit.UIColor.UIColor
import class    UIKit.UINavigationController.UINavigationController
import protocol UIKit.UINavigationController.UINavigationControllerDelegate
import enum     UIKit.UINavigationController.UINavigationControllerOperation
import class	UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerInteractiveTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

/// Payment View Controller.
internal class PaymentViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
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
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

       // self.paymentOptionsTableView?.reloadData()
        ThemeManager.shared.resetCurrentThemeToDefault()
        themeChanged()
        self.blurView?.style = Theme.current.commonStyle.blurStyle[Process.shared.appearance].style
        PaymentContentViewController.tap_findInHierarchy()?.themeChanged()
        PaymentOptionsViewController.tap_findInHierarchy()?.themeChanged()
        
    }

    private var hasShownPaymentController = false
	
	private lazy var animationsHandler: TransitionAnimationsHandler = {
		
		let additionalAppearanceAnimations: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.view.layer.backgroundColor = Theme.current.commonStyle.backgroundColor[.fullscreen].color.cgColor
		}
		
		let additionalDisapperanceAnimations: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.view.layer.backgroundColor = UIColor.clear.cgColor
		}
		
		return TransitionAnimationsHandler(additionalAppearanceAnimations:		additionalAppearanceAnimations,
										   additionalDisappearanceAnimations:	additionalDisapperanceAnimations)
	}()
    
    // MARK: Methods
    
    private func showPaymentController() {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.performSegue(withIdentifier: "\(ResizablePaymentContainerViewController.tap_className)Segue", sender: self)
        }
        
        self.hasShownPaymentController = true
    }
}

// MARK: - InstantiatableFromStoryboard
extension PaymentViewController: InstantiatableFromStoryboard {
	
	internal static var hostingStoryboard: UIStoryboard {
		
		return .goSellSDKPayment
	}
}

// MARK: - TransitionAnimationsHandler
extension PaymentViewController {
    
    private class TransitionAnimationsHandler: NSObject, UIViewControllerTransitioningDelegate {
		
		fileprivate init(additionalAppearanceAnimations: TypeAlias.ArgumentlessClosure?, additionalDisappearanceAnimations: TypeAlias.ArgumentlessClosure?) {
			
			self.additionalAppearanceAnimations		= additionalAppearanceAnimations
			self.additionalDisappearanceAnimations	= additionalDisappearanceAnimations
			
			super.init()
		}
		
		fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			
			let animationController = PaymentPresentationAnimationController()
			animationController.additionalAnimations = self.additionalAppearanceAnimations
			
			return animationController
		}
		
		fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			
			let animationController = PaymentDismissalAnimationController()
			animationController.additionalAnimations = self.additionalDisappearanceAnimations
			
			return animationController
		}
		
		private let additionalAppearanceAnimations: TypeAlias.ArgumentlessClosure?
		private let additionalDisappearanceAnimations: TypeAlias.ArgumentlessClosure?
    }
}
