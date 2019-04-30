//
//  UIImage+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIImage.UIImage

internal extension UIImage {
	
	// MARK: - Internal -
	// MARK: Properties
	
	var tap_asResourceImage: ResourceImage {
		
		return ResourceImage(data: self.tap_pngData!, scale: scale)!
	}
}
