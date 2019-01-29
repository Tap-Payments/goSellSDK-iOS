//
//  SDKAppearanceMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// SDK appearance mode.
///
/// - fullscreen: SDK UI will appear fullscreen.
/// - windowed: SDK UI will try to take as little space on the screen as possible.
/// - default: Default mode is fullscreen for Payment and Authorization and windowed for saving the card.
@objc public enum SDKAppearanceMode: Int, CaseIterable {
	
	@objc(Fullscreen) case fullscreen
	@objc(Windowed) case windowed
	@objc(Default) case `default`
}

extension SDKAppearanceMode: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
			
		case .fullscreen:	return "Fullscreen"
		case .windowed:		return "Windowed"
		case .default:		return "Default"

		}
	}
}
