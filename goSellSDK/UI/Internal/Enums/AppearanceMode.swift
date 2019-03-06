//
//  AppearanceMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Internal SDK appearance mode.
///
/// - fullscreen: Fullscreen mode.
/// - windowed: Windowed mode.
internal enum AppearanceMode: String, Decodable {
	
	case fullscreen
	case windowed
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal init(publicAppearance: SDKAppearanceMode, transactionMode: TransactionMode) {
		
		switch publicAppearance {
			
		case .fullscreen:	self = .fullscreen
		case .windowed:		self = .windowed
		case .default:		self = transactionMode == .cardSaving ? .windowed : .fullscreen
		}
	}
}
