//
//  UIBlurEffect.Style+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIBlurEffect.UIBlurEffect

// MARK: - CaseIterable
extension UIBlurEffect.Style: CaseIterable {
	
	public static var allCases: [UIBlurEffect.Style] {
		
		if #available(iOS 10.0, *) {
			
			return [
			
				.light,
				.extraLight,
				.dark,
				.prominent,
				.regular
			]
		}
		else {
			
			return [
				
				.light,
				.extraLight,
				.dark
			]
		}
	}
}

// MARK: - CustomStringConvertible
extension UIBlurEffect.Style: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
			
		case .light:		return "Light"
		case .extraLight:	return "Extra Light"
		case .dark:			return "Dark"
		case .prominent:	return "Prominent"
		case .regular:		return "Regular"
			
		@unknown default:	return "Unknown"

		}
	}
}

// MARK: - Decodable
extension UIBlurEffect.Style: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		
		let string = try container.decode(String.self)
		
		switch string {
			
		case UIBlurEffectStyleConstants.light:
			
			self = .light
			
		case UIBlurEffectStyleConstants.extraLight:
			
			self = .extraLight
			
		case UIBlurEffectStyleConstants.dark:
			
			self = .dark
			
		case UIBlurEffectStyleConstants.prominent:
			
			if #available(iOS 10.0, *) {
				
				self = .prominent
			}
			else {
				
				self = .light
			}
			
		case UIBlurEffectStyleConstants.regular:
			
			if #available(iOS 10.0, *) {
				
				self = .regular
			}
			else {
				
				self = .light
			}
			
		default:
			
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown blur style value: \(string)"))
		}
	}
}

// MARK: - Encodable
extension UIBlurEffect.Style: Encodable {
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		
		switch self {
			
		case .light:
			
			try container.encode(UIBlurEffectStyleConstants.light)
			
		case .extraLight:
			
			try container.encode(UIBlurEffectStyleConstants.extraLight)
			
		case .dark:
			
			try container.encode(UIBlurEffectStyleConstants.dark)
			
		case .prominent:
			
			try container.encode(UIBlurEffectStyleConstants.prominent)
			
		case .regular:
			
			try container.encode(UIBlurEffectStyleConstants.regular)
			
		@unknown default:
			
			try container.encode(UIBlurEffectStyleConstants.light)
		}
	}
}

private struct UIBlurEffectStyleConstants {
	
	fileprivate static let light		= "light"
	fileprivate static let dark			= "dark"
	fileprivate static let extraLight	= "extra_light"
	fileprivate static let prominent	= "prominent"
	fileprivate static let regular		= "regular"
	
	@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
}
