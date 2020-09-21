//
//  AddressType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Address type.
///
/// - residential: Residential address.
/// - commercial: Commercial address.
@objc public enum AddressType: Int {
	
	/// Residential address.
    @objc(Residential) case residential
	
	/// Commercial address
    @objc(Commercial) case commercial
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal init(string: String) throws {
		
		switch string.uppercased() {
			
		case Constants.residentialKey: self = .residential
		case Constants.commercialKey:  self = .commercial
			
		default:
			
			let userInfo = [ErrorConstants.UserInfoKeys.addressType: string]
			let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidAddressType.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
		}
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let residentialKey	= "RESIDENTIAL"
		fileprivate static let commercialKey	= "COMMERCIAL"
		
		//@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	private var stringValue: String {
		
		switch self {
			
		case .residential:	return Constants.residentialKey
		case .commercial:	return Constants.commercialKey

		}
	}
}

// MARK: - Decodable
extension AddressType: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		
		let string = try container.decode(String.self)
		try self.init(string: string)
	}
}

// MARK: - Encodable
extension AddressType: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.stringValue)
	}
}
