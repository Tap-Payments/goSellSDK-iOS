//
//  UIImage+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGPoint
import struct	CoreGraphics.CGGeometry.CGRect
import struct	CoreGraphics.CGGeometry.CGSize
import class	UIKit.UIColor.UIColor
import func		UIKit.UIGraphics.UIGraphicsBeginImageContextWithOptions
import func		UIKit.UIGraphics.UIGraphicsEndImageContext
import func		UIKit.UIGraphics.UIGraphicsGetCurrentContext
import func		UIKit.UIGraphics.UIGraphicsGetImageFromCurrentImageContext
import class	UIKit.UIImage.UIImage
import func		UIKit.UIGraphics.UIRectFill

internal extension UIImage {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var tap_asResourceImage: ResourceImage {
		
		return ResourceImage(data: self.pngData()!, scale: scale)!
	}
	
	// MARK: Methods
	
	internal convenience init?(byCombining images: [UIImage]) {
		
		let sizes = images.map { $0.size }
		
		let maxWidth	= sizes.max { $0.width < $1.width }!.width
		let maxHeight	= sizes.max { $0.height < $1.height }!.height

		var imagesDictionary: [NSValue: UIImage] = [:]
		for image in images {
			
			let size = image.size
			let location = CGPoint(x: 0.5 * (maxWidth - size.width), y: 0.5 * (maxHeight - size.height))
			imagesDictionary[NSValue(cgPoint: location)] = image
		}
		
		let resultingSize = CGSize(width: maxWidth, height: maxHeight)
		
		self.init(tap_byCombiningImages: imagesDictionary, withResultingSize: resultingSize, backgroundColor: .clear, clearImageLocations: false)
	}
	
	internal func tap_byApplyingTint(color: UIColor) -> UIImage? {
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()
		context?.saveGState()
		
		let bounds = CGRect(origin: .zero, size: self.size)
		
		color.setFill()
		UIRectFill(bounds)
		
		self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		
		context?.restoreGState()
		UIGraphicsEndImageContext()
		
		return image
	}
}
