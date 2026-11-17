//
//  StatusBarStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import enum		UIKit.UIApplication.UIStatusBarStyle

internal enum StatusBarStyle: String, Decodable {

	case light	= "light"
	case dark	= "dark"
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var uiStatusBarStyle: UIStatusBarStyle {
		
		switch self {
			
		case .light:	return .lightContent
		case .dark:		return .default
			
		}
	}
}
