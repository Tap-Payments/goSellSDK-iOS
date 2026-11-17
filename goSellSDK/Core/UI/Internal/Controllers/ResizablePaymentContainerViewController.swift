//
//  ResizablePaymentContainerViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
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
		self.pinContentToHorizontalSafeArea()
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
	
	internal override func viewSafeAreaInsetsDidChange() {
		
		super.viewSafeAreaInsetsDidChange()
		
		// With no status bar on top (an unfolded foldable iPhone in landscape has it on a side edge) the
		// system's top inset is 0 and the header touched the top edge. Add a small top inset then, so the
		// content keeps some space in both fullscreen and windowed appearance.
		let systemTopInset = self.view.safeAreaInsets.top - self.additionalSafeAreaInsets.top
		let requiredAdditionalTopInset = systemTopInset > 0.0 ? 0.0 : Constants.minimalTopSpacing
		
		if self.additionalSafeAreaInsets.top != requiredAdditionalTopInset {
			
			self.additionalSafeAreaInsets.top = requiredAdditionalTopInset
		}
		
		if let contentSize = self.contentNavigationController?.topViewController?.preferredContentSize {
			
			self.resizeNavigationController(to: contentSize, animated: false)
		}
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
		
		/// Space kept above the sheet when the screen has no top inset (an unfolded foldable iPhone in
		/// landscape, where the status bar is on a side edge), so the header doesn't touch the top edge.
		fileprivate static let minimalTopSpacing: CGFloat = 20.0
		
		//@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	@IBOutlet private weak var bottomContentOffsetConstraint: NSLayoutConstraint?
	@IBOutlet private weak var topContentOffsetConstraint: NSLayoutConstraint?
	
	@IBOutlet private weak var contentContainerView: UIView?
	
	private weak var contentNavigationController: UINavigationController?
	
	private lazy var navigationControllerDelegate = ResizableNavigationControllerDelegate(resizableContainerController: self)
	
	private var forcedFullscreen = false
	
	/// When the content is taller than the screen, the windowed sheet used to start at the very top
	/// (offset 0), under the status bar or flush with the top edge. Keep it below the top safe-area
	/// inset (which includes `minimalTopSpacing` when the system has none). Forced fullscreen
	/// (web/3-D Secure) still covers everything.
	private var minimalTopOffset: CGFloat {
		
		guard !self.forcedFullscreen else { return 0.0 }
		return self.view.safeAreaInsets.top
	}
	
	// MARK: Methods
	
	/// Keeps the sheet's content out of the side safe-area insets (the status bar and camera on the
	/// side of an unfolded foldable iPhone in landscape). The blurred background stays full width.
	private func pinContentToHorizontalSafeArea() {
		
		guard let containerView = self.contentContainerView else { return }
		self.view.tap_pinToHorizontalSafeArea(containerView)
	}
	
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
		let requiredTopOffset = min(max(desiredTopOffset, self.minimalTopOffset), maximalHeight)
		
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
