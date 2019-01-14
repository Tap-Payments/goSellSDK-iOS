//
//  LayoutDirectionObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class	UIKit.UIView.UIView

internal protocol LayoutDirectionObserver: ClassProtocol {
	
	var viewToUpdateLayoutDirection: UIView { get }
	func layoutDirectionChanged()
}

internal extension LayoutDirectionObserver {
	
	internal func startMonitoringLayoutDirectionChanges() {
		
		NotificationCenter.default.addObserver(forName: .sdkLayoutDirectionChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.viewToUpdateLayoutDirection.updateLayoutDirectionIfRequired()
			self?.layoutDirectionChanged()
		}
	}
	
	internal func stopMonitoringLayoutDirectionChanges() {
		
		NotificationCenter.default.removeObserver(self, name: .sdkLayoutDirectionChanged, object: nil)
	}
	
	internal func layoutDirectionChanged() {}
}
