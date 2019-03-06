//
//  Color.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSRange.NSRange
import class	UIKit.UIColor.UIColor

internal enum Color {
	
	case black
	case darkGray
	case lightGray
	case white
	case gray
	case red
	case green
	case blue
	case cyan
	case yellow
	case magenta
	case orange
	case purple
	case brown
	case clear
	
	case custom(String)
	
	internal var asUIColor: UIColor {
		
		switch self {
			
		case .black:			return .black
		case .darkGray:			return .darkGray
		case .lightGray:		return .lightGray
		case .white:			return .white
		case .gray:				return .gray
		case .red:				return .red
		case .green:			return .green
		case .blue:				return .blue
		case .cyan:				return .cyan
		case .yellow:			return .yellow
		case .magenta:			return .magenta
		case .orange:			return .orange
		case .purple:			return .purple
		case .brown:			return .brown
		case .clear:			return .clear
		case .custom(let hex):	return UIColor(tap_hex: hex)!
			
		}
	}
}

// MARK: - CaseIterable
extension Color: CaseIterable {
	
	internal static var allCases: [Color] {
		
		return [
		
			.black,
			.darkGray,
			.lightGray,
			.white,
			.gray,
			.red,
			.green,
			.blue,
			.cyan,
			.yellow,
			.magenta,
			.orange,
			.purple,
			.brown,
			.clear,
			.custom("#535353"),
			.custom("#ee0000"),
			.custom("#bdbdbd"),
			.custom("#5c5c5c"),
			.custom("#2ace00")
		]
	}
}

// MARK: - CustomStringConvertible
extension Color: CustomStringConvertible {
	
	internal var description: String {
		
		switch self {
			
		case .black:			return "Black"
		case .darkGray:			return "Dark Gray"
		case .lightGray:		return "Light Gray"
		case .white:			return "White"
		case .gray:				return "Gray"
		case .red:				return "Red"
		case .green:			return "Green"
		case .blue:				return "Blue"
		case .cyan:				return "Cyan"
		case .yellow:			return "Yellow"
		case .magenta:			return "Magenta"
		case .orange:			return "Orange"
		case .purple:			return "Purple"
		case .brown:			return "Brown"
		case .clear:			return "Clear"
		case .custom(let hex):	return "Custom (\(hex))"
		}
	}
}

// MARK: - Encodable
extension Color: Encodable {
	
	internal func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.description)
	}
}

// MARK: - Decodable
extension Color: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let stringValue = try container.decode(String.self)
		
		if stringValue.hasPrefix("Custom (") && stringValue.hasSuffix(")") {
			
			let hexLocation = "Custom (".tap_length
			let hexLength = stringValue.tap_length - hexLocation - ")".tap_length
			
			guard let hex = stringValue.tap_substring(with: NSRange(location: hexLocation, length: hexLength)) else {
				
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot parse color from string: \(stringValue)"))
			}
			
			self = .custom(hex)
		}
		else {
			
			for color in Color.allCases {
				
				if color.description == stringValue {
					
					self = color
					return
				}
			}
			
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot parse color from string: \(stringValue)"))
		}
	}
}
