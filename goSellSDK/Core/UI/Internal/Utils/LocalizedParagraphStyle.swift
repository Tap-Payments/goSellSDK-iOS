//
//  LocalizedParagraphStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import class	UIKit.NSParagraphStyle.NSMutableParagraphStyle
import enum 	UIKit.NSText.NSTextAlignment

internal class LocalizedParagraphStyle: NSMutableParagraphStyle {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal override var alignment: NSTextAlignment {
		
		get {
			
			return self.localizedAlignment.textAlignment
		}
		set {
			
			super.alignment = newValue
		}
	}
	
	internal var localizedAlignment: LocalizedTextAlignment = .left
}
