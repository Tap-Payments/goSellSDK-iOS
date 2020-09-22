//
//  LoadingView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	TapGLKitV2.TapActivityIndicatorView
import class	TapNibViewV2.TapNibView
import class	TapVisualEffectViewV2.TapVisualEffectView
import class	UIKit.UILabel.UILabel
import class	UIKit.UIView.UIView

internal final class LoadingView: TapNibView {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal override class var bundle: Bundle {
		
		return .goSellSDKResources
	}
	
	// MARK: Methods
	
	internal static func show(in container: LoadingViewSupport, animated: Bool, descriptionText: String? = nil) {
		
		let bounds = container.loadingViewContainer.bounds
		
		let loadingView = LoadingView(frame: bounds)
		loadingView.descriptionText = descriptionText
		
		loadingView.add(to: container.loadingViewContainer, animated: animated)
	}
	
	internal static func remove(from container: LoadingViewSupport, animated: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		if let loadingView = container.loadingViewContainer.tap_subview(ofClass: LoadingView.self) {
			
			loadingView.removeFromView(animated: animated, completion: completion)
		}
		else {
			
			completion?()
		}
	}
	
	internal override func setup() {
		
		super.setup()
		
		self.updateDescription()
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let animationDuration: TimeInterval = 0.3
	}
	
	// MARK: Properties
	
	@IBOutlet private weak var loader: TapActivityIndicatorView? {
		
		didSet {
			
			self.loader?.animationDuration  = Theme.current.commonStyle.loaderAnimationDuration
			self.loader?.usesCustomColors   = true
			self.loader?.outterCircleColor  = .tap_hex("535353")
			self.loader?.innerCircleColor   = .tap_hex("535353")
			self.loader?.startAnimating()
		}
	}
	
	@IBOutlet private weak var backgroundBlurView: TapVisualEffectView?
	
	@IBOutlet private weak var descriptionLabel: UILabel?
	
	private var descriptionText: String? {
		
		didSet {
			
			self.updateDescription()
		}
	}
	
	// MARK: Methods
	
	private func add(to view: UIView, animated: Bool) {
		
		self.updateForVisibleState(false)
		view.tap_addSubviewWithConstraints(self)
		
		UIView.animate(withDuration: animated ? Constants.animationDuration : 0.0) {
			
			self.updateForVisibleState(true)
		}
	}
	
	private func removeFromView(animated: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		self.updateForVisibleState(true)
		
		let animations: TypeAlias.ArgumentlessClosure = {
			
			self.updateForVisibleState(false)
		}
		
		UIView.animate(withDuration: animated ? Constants.animationDuration : 0.0, animations: animations) { _ in
			
			self.removeFromSuperview()
			completion?()
		}
	}
	
	private func updateDescription() {
		
		self.descriptionLabel?.text = self.descriptionText
	}
	
	private func updateForVisibleState(_ visible: Bool) {
		
		self.alpha = visible ? 1.0 : 0.0
		self.backgroundBlurView?.style = visible ? .light : .none
	}
}
