//
//  ResourceImage.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage

internal final class ResourceImage: UIImage, Decodable {
	
	required internal convenience init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let imageName = try container.decode(String.self)
		
		let image = UIImage(named: imageName, in: .goSellSDKResources, compatibleWith: nil)!
		let imageData = image.tap_pngData!
		
		self.init(data: imageData, scale: image.scale)!
	}
}
