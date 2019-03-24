//
//  AuthorizeActionType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Authorize action type.
@objc public enum AuthorizeActionType: Int {
    
    /// Capture authorization action.
    @objc(Capture) case capture
    
    /// Void authorization action.
    @objc(Void) case void
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .capture:  return "CAPTURE"
        case .void:     return "VOID"
            
        }
    }
    
    // MARK: Methods
    
    private init(stringValue: String) throws {
        
        switch stringValue {
            
        case AuthorizeActionType.capture.stringRepresentation: self = .capture
        case AuthorizeActionType.void.stringRepresentation: self = .void
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.authorizeActionType: stringValue]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidAuthorizeActionType.rawValue, userInfo: userInfo)
    
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
    }
}

// MARK: - Decodable
extension AuthorizeActionType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let string = try container.decode(String.self)
        try self.init(stringValue: string)
    }
}

// MARK: - Encodable
extension AuthorizeActionType: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}
