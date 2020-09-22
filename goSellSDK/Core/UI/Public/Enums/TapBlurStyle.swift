//
//  TapBlurStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum	TapVisualEffectViewV2.TapBlurEffectStyle

/// Blur style.
///
/// - none: No blur.
/// - light: Light blur
/// - extraLight: Extra light blur
/// - dark: Dark blur
/// - regular: Regular blur
/// - prominent: Prominent blur.
@objc public final class TapBlurStyle: NSObject {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// No blur.
	public static let none			= TapBlurStyle(rawValue: 0)
	
	/// Light blur.
	public static let light			= TapBlurStyle(rawValue: 1)
	
	/// Extra light blur.
	public static let extraLight	= TapBlurStyle(rawValue: 2)
	
	/// Dark blur.
	public static let dark			= TapBlurStyle(rawValue: 3)
	
	/// Regular blur.
	@available(iOS 10.0, *)
	public static let regular		= TapBlurStyle(rawValue: 4)
	
	/// Prominent blur.
	@available(iOS 10.0, *)
	public static let prominent		= TapBlurStyle(rawValue: 5)
	
	/// Description.
	public override var description: String {
		
		if #available(iOS 10.0, *) {
			
			switch self {
				
			case .none:			return "None"
			case .light:		return "Light"
			case .extraLight:	return "Extra Light"
			case .dark:			return "Dark"
			case .regular:		return "Regular"
			case .prominent:	return "Prominent"
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
		else {
			
			switch self {
				
			case .none:			return "None"
			case .light:		return "Light"
			case .extraLight:	return "Extra Light"
			case .dark:			return "Dark"
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
	}
	
	// MARK: Methods
	
	/// Defines if the receiver is equal to an `object`.
	///
	/// - Parameter object: Object to compare to.
	/// - Returns: Bool
	public override func isEqual(_ object: Any?) -> Bool {
		
		guard let otherStyle = object as? TapBlurStyle else { return false }
		
		return self.rawValue == otherStyle.rawValue
	}
	
	/// Defines if `lhs` is equal to `rhs`.
	///
	/// - Parameters:
	///   - lhs: First object.
	///   - rhs: Second object.
	/// - Returns: Bool
	public static func == (lhs: TapBlurStyle, rhs: TapBlurStyle) -> Bool {
		
		return lhs.rawValue == rhs.rawValue
	}
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var effectStyle: TapBlurEffectStyle {
		
		if #available(iOS 10.0, *) {
			
			switch self {
				
			case .none:			return .none
			case .light:		return .light
			case .extraLight:	return .extraLight
			case .dark:			return .dark
			case .regular:		return .regular
			case .prominent:	return .prominent
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
		else {
			
			switch self {
				
			case .none:			return .none
			case .light:		return .light
			case .extraLight:	return .extraLight
			case .dark:			return .dark
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let lightRawValue		= "light"
		fileprivate static let extraLightRawValue	= "extra_light"
		fileprivate static let darkRawValue			= "dark"
		fileprivate static let regularRawValue		= "regular"
		fileprivate static let prominentRawValue	= "prominent"
		fileprivate static let noneRawValue			= "none"
		
		//@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	private let rawValue: Int
	
	// MARK: Methods
	
	private init(rawValue: Int) {
		
		self.rawValue = rawValue
		
		super.init()
	}
}

// MARK: - CaseIterable
extension TapBlurStyle: CaseIterable {
	
	public static var allCases: [TapBlurStyle] {
		
		if #available(iOS 10.0, *) {
		
			return [.none, light, .extraLight, .dark, .prominent, .regular]
		}
		else {
			
			return [.none, light, .dark]
		}
	}
}

// MARK: - Decodable
extension TapBlurStyle: Decodable {
	
	public convenience init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		
		let string = try container.decode(String.self)
		
		if #available(iOS 10.0, *) {
			
			switch string {
				
			case Constants.lightRawValue:
				
				self.init(rawValue: TapBlurStyle.light.rawValue)
				
			case Constants.darkRawValue:
				
				self.init(rawValue: TapBlurStyle.dark.rawValue)
				
			case Constants.extraLightRawValue:
				
				self.init(rawValue: TapBlurStyle.extraLight.rawValue)
				
			case Constants.regularRawValue:
				
				self.init(rawValue: TapBlurStyle.regular.rawValue)
				
			case Constants.prominentRawValue:
				
				self.init(rawValue: TapBlurStyle.prominent.rawValue)
				
			default:
				
				self.init(rawValue: TapBlurStyle.none.rawValue)
			}
		}
		else {
			
			switch string {
				
			case Constants.lightRawValue:
				
				self.init(rawValue: TapBlurStyle.light.rawValue)
				
			case Constants.darkRawValue:
				
				self.init(rawValue: TapBlurStyle.dark.rawValue)
				
			case Constants.extraLightRawValue:
				
				self.init(rawValue: TapBlurStyle.extraLight.rawValue)
				
			case Constants.regularRawValue:
				
				self.init(rawValue: TapBlurStyle.light.rawValue)
				
			case Constants.prominentRawValue:
				
				self.init(rawValue: TapBlurStyle.extraLight.rawValue)
				
			default:
				
				self.init(rawValue: TapBlurStyle.none.rawValue)
			}
		}
	}
}

// MARK: - Encodable
extension TapBlurStyle: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		
		var string: String
		
		if #available(iOS 10.0, *) {
			
			switch self {
				
			case .none:			string = Constants.noneRawValue
			case .light:		string = Constants.lightRawValue
			case .dark:			string = Constants.darkRawValue
			case .extraLight:	string = Constants.extraLightRawValue
			case .regular:		string = Constants.regularRawValue
			case .prominent:	string = Constants.prominentRawValue
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
		else {
			
			switch self {
				
			case .none:			string = Constants.noneRawValue
			case .light:		string = Constants.lightRawValue
			case .dark:			string = Constants.darkRawValue
			case .extraLight:	string = Constants.extraLightRawValue
				
			default:
				
				fatalError("Unknown blur style.")
			}
		}
		
		try container.encode(string)
	}
}
