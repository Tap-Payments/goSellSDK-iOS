//
//  UIEdgeInsets+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

#if !swift(>=5)

import struct	CoreGraphics.CGBase.CGFloat
import struct	UIKit.UIGeometry.UIEdgeInsets

fileprivate extension UIEdgeInsets {
	
	private enum CodingKeys: String, CodingKey {

		case top	= "top"
		case left	= "left"
		case bottom	= "bottom"
		case right	= "right"
	}
}

// MARK: - Decodable
extension UIEdgeInsets: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let top		= try container.decode(CGFloat.self, forKey: .top)
		let left	= try container.decode(CGFloat.self, forKey: .left)
		let bottom	= try container.decode(CGFloat.self, forKey: .bottom)
		let right	= try container.decode(CGFloat.self, forKey: .right)
		
		self.init(top: top, left: left, bottom: bottom, right: right)
	}
}

// MARK: - Encodable
extension UIEdgeInsets: Encodable {
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(self.top,		forKey: .top)
		try container.encode(self.left, 	forKey: .left)
		try container.encode(self.bottom,	forKey: .bottom)
		try container.encode(self.right,	forKey: .right)
	}
}

#endif
