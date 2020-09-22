//
//  ResizablePaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGSize
import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.NSLayoutConstraint.NSLayoutConstraint
import class	UIKit.UIApplication.UIApplication
import enum		UIKit.UIApplication.UIStatusBarStyle
import class	UIKit.UINavigationController.UINavigationController
import protocol	UIKit.UINavigationController.UINavigationControllerDelegate
import class	UIKit.UIStoryboardSegue.UIStoryboardSegue
import class	UIKit.UIView.UIView
import class	UIKit.UIViewController.UIViewController
import protocol	UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol	UIKit.UIViewControllerTransitioning.UIViewControllerInteractiveTransitioning

internal class ResizablePaymentContainerViewController: BaseViewController
{
    
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		if let topOffsetConstraint = self.topContentOffsetConstraint, topOffsetConstraint.constant == 0.0 {
			
			return Theme.current.commonStyle.statusBar[.fullscreen].uiStatusBarStyle
		}
		
		if let topControllerPreferredStyle = self.contentNavigationController?.topViewController?.preferredStatusBarStyle {
			
			return topControllerPreferredStyle
		}
		else {
			
			return Theme.current.commonStyle.statusBar[Process.shared.appearance].uiStatusBarStyle
		}
	}
	
	internal var currentContentViewController: UIViewController? {
		
		return self.contentNavigationController?.topViewController
	}
	
	// MARK: Methods
	
	internal override func viewDidLoad() {
		
		super.viewDidLoad()
		self.ignoresKeyboardEventsWhenWindowIsNotKey = true
	}
	
	internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		super.prepare(for: segue, sender: sender)
		
		if	let navigationController		= segue.destination as? UINavigationController,
			let paymentContentController	= navigationController.tap_rootViewController as? PaymentContentViewController {
			
			self.contentNavigationController = navigationController
			
			navigationController.delegate = self.navigationControllerDelegate
			paymentContentController.layoutListener = self
		}
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		self.setNeedsStatusBarAppearanceUpdate()
		
		self.contentContainerView?.backgroundColor = Theme.current.commonStyle.contentBackgroundColor[Process.shared.appearance].color
	}
	
	internal func makeFullscreen(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		self.forcedFullscreen = true
		self.resizeNavigationController(to: self.view.bounds.size, animated: true, completion: completion)
	}
	
	internal func makeWindowedBack(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		self.forcedFullscreen = false
		
		let contentSize = self.contentNavigationController?.topViewController?.preferredContentSize ?? self.view.bounds.size
		self.resizeNavigationController(to: contentSize, animated: true, completion: completion)
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let navigationControllerContentSizeChangeAnimationDuration: TimeInterval = 0.3
		
		//@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	@IBOutlet private weak var bottomContentOffsetConstraint: NSLayoutConstraint?
	@IBOutlet private weak var topContentOffsetConstraint: NSLayoutConstraint?
	
	@IBOutlet private weak var contentContainerView: UIView?
	
	private weak var contentNavigationController: UINavigationController?
	
	private lazy var navigationControllerDelegate = ResizableNavigationControllerDelegate(resizableContainerController: self)
	
	private var forcedFullscreen = false
	
	// MARK: Methods
	
	private func resizeNavigationController(to size: CGSize, animated: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		let appliedSize = self.forcedFullscreen ? self.view.bounds.size : size
		
		guard
			
			let topOffsetConstraint = self.topContentOffsetConstraint,
			let bottomOffsetConstraint = self.bottomContentOffsetConstraint,
			
			Process.shared.appearance == .windowed,
			appliedSize.tap_area > 0.0
			
		else {
			
			completion?()
			return
		}
		
		let maximalHeight = self.view.bounds.height - bottomOffsetConstraint.constant
		let desiredTopOffset = maximalHeight - appliedSize.height
		let requiredTopOffset = min(max(desiredTopOffset, 0.0), maximalHeight)
		
		guard topOffsetConstraint.constant != requiredTopOffset else {
			
			completion?()
			return
		}
		
		topOffsetConstraint.constant = requiredTopOffset
		
		if animated {
			
			let animationOptions: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseInOut]
			let animations: TypeAlias.ArgumentlessClosure = { [unowned self] in
				
				self.setNeedsStatusBarAppearanceUpdate()
				self.view.tap_layout()
			}
			
			UIView.animate(withDuration:	Constants.navigationControllerContentSizeChangeAnimationDuration,
						   delay:			0.0,
						   options:			animationOptions,
						   animations:		animations) { _ in
							
				completion?()
			}
		}
		else {
			
			self.view.tap_layout()
			completion?()
		}
	}
}

// MARK: - ViewControllerLayoutListener
extension ResizablePaymentContainerViewController: ViewControllerLayoutListener {
	
	internal func viewControllerViewDidLayoutSubviews(_ viewController: UIViewController) {
		
		if self.contentNavigationController?.topViewController == viewController {
			
			self.resizeNavigationController(to: viewController.preferredContentSize, animated: !self.isBeingPresented)
		}
	}
}

// MARK: - ResizableNavigationControllerDelegate
private extension ResizablePaymentContainerViewController {
	
	private class ResizableNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
		
		// MARK: - Fileprivate -
		// MARK: Methods
		
		fileprivate init(resizableContainerController: ResizablePaymentContainerViewController) {
			
			self.resizableContainerController = resizableContainerController
		}
		
		fileprivate func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			
			if operation == .push {
				
				if let headerController = toVC as? HeaderNavigatedViewController, Process.shared.appearance == .fullscreen {
					
					let interactivePopTransition = UINavigationControllerPopInteractionController(viewController: headerController)
					headerController.interactivePopTransition = interactivePopTransition
				}
			}
			
			return UINavigationControllerSideAnimationController(operation: operation, from: fromVC, to: toVC)
		}
		
		fileprivate func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
			
			if
				let sideAnimationController     = animationController as? UINavigationControllerSideAnimationController,
				let interactiveViewController   = sideAnimationController.fromViewController as? InteractivePopViewController,
				let interactiveTransition       = interactiveViewController.interactivePopTransition,
				
				interactiveTransition.isInteracting,
				sideAnimationController.operation == .pop {
				
				return interactiveTransition
			}
			else {
				
				return nil
			}
		}
		
		fileprivate func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
			
			DispatchQueue.main.async {
				
				self.resizableContainerController.resizeNavigationController(to: viewController.preferredContentSize, animated: animated)
			}
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let resizableContainerController: ResizablePaymentContainerViewController
	}
}
