//
//  TapEdgeInsets.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct	UIKit.UIGeometry.UIEdgeInsets

internal struct TapEdgeInsets: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let top: CGFloat
	
	internal let left: CGFloat
	
	internal let bottom: CGFloat
	
	internal let right: CGFloat
	
	// MARK: Methods
	
	internal init(_ uiEdgeInsets: UIEdgeInsets) {
		
		self.top	= uiEdgeInsets.top
		self.left	= uiEdgeInsets.left
		self.bottom	= uiEdgeInsets.bottom
		self.right	= uiEdgeInsets.right
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case top	= "top"
		case left	= "left"
		case bottom	= "bottom"
		case right	= "right"
	}
}
