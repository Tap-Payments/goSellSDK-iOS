//
//  CardVerificationStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Card Verification Status.
@objc public enum CardVerificationStatus: Int {
	
	/// Card verification initiated.
	case initiated	= 0
	
	/// Card is valid.
	case valid
	
	/// Card is invalid.
	case invalid
	
	// MARK: - Private -
	// MARK: Properties
	
	private var stringValue: String {
		
		switch self {
			
		case .initiated:    return "INITIATED"
		case .valid:		return "VALID"
		case .invalid:		return "INVALID"
		
		}
	}
	
	// MARK: Methods
	
	private init(_ stringValue: String) throws {
		
		switch stringValue {
			
		case CardVerificationStatus.initiated.stringValue:	self = .initiated
		case CardVerificationStatus.valid.stringValue:		self = .valid
		case CardVerificationStatus.invalid.stringValue:	self = .invalid
			
		default:
			
			throw ErrorUtils.createEnumStringInitializationError(for: CardVerificationStatus.self, value: stringValue)
		}
	}
}

// MARK: - Decodable
extension CardVerificationStatus: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let stringValue = try container.decode(String.self)
		
		try self.init(stringValue)
	}
}
