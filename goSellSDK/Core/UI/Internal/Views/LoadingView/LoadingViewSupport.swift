//
//  LoadingViewSupport.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.UIView.UIView

internal protocol LoadingViewSupport {
	
	var loadingViewContainer: UIView { get }
}

extension LoadingViewSupport {
	
	internal func hideLoader(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		if let loadingController = self as? LoadingViewController {
			
			loadingController.hide(animated: true, async: true, fromDestroyInstance: false, completion: completion)
		}
		else {
			
			LoadingView.remove(from: self, animated: true, completion: completion)
		}
	}
}
