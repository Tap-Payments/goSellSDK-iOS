//
//  MirrorableView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIView.UIView

internal class MirrorableView: UIView {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal override func didMoveToSuperview() {
		
		super.didMoveToSuperview()
		
		if self.superview != nil {
			
			self.updateLayoutDirectionIfRequired()
			self.updateTransformIfRequired()
			self.startMonitoringLayoutDirectionChanges()
		}
	}
	
	internal override func willMove(toSuperview newSuperview: UIView?) {
		
		super.willMove(toSuperview: newSuperview)
		if newSuperview == nil {
			
			self.stopMonitoringLayoutDirectionChanges()
		}
	}
	
	internal func layoutDirectionChanged() {
		
		self.updateTransformIfRequired()
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	private func updateTransformIfRequired() {
		
		if #available(iOS 9.0, *) {
			
			let currentTransform = self.transform
			let requiredTransform = currentTransform.scaledBy(x: self.semanticContentAttribute == .forceRightToLeft ? -1.0 : 1.0, y: 1.0)
			
			if currentTransform != requiredTransform {
				
				self.transform = requiredTransform
			}
		}
	}
}

// MARK: - LayoutDirectionObserver
extension MirrorableView: LayoutDirectionObserver {
	
	internal var viewToUpdateLayoutDirection: UIView { return self }
}
