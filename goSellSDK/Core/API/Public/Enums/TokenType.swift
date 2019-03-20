//
//  TokenType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Token type.
///
/// - card: Card token.
/// - savedCard: Saved card token.
@objc public enum TokenType: Int {
	
	/// Card token.
    @objc(TokenTypeCard) case card
	
	/// Saved card token.
    @objc(TokenTypeSavedCard) case savedCard
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let cardKey	= "CARD"
		fileprivate static let savedCardKey	= "SAVED_CARD"
		
		@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	private var stringValue: String {
		
		switch self {
			
		case .card:			return Constants.cardKey
		case .savedCard:	return Constants.savedCardKey
			
		}
	}
	
	// MARK: Methods
	
	private init(string: String) throws {
		
		switch string.uppercased() {
			
		case Constants.cardKey:			self = .card
		case Constants.savedCardKey:	self = .savedCard
			
		default:
			
			let userInfo = [ErrorConstants.UserInfoKeys.tokenType: string]
			let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidTokenType.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
		}
	}
}

// MARK: - Decodable
extension TokenType: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		
		let string = try container.decode(String.self)
		try self.init(string: string)
	}
}
