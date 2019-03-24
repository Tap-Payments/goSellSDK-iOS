//
//  TapSDKError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Base abstract class for errors.
@objcMembers public class TapSDKError: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Error type.
    public private(set) var type: TapSDKErrorType = .unknown
    
    /// Pretty printed description of TapSDKError object.
    public override var description: String {
        
        return "Error type: \(self.type.description)"
    }
	
	// MARK: Methods
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(self.type, forKey: .type)
	}
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Designated initializer for the errors.
    ///
    /// - Parameter type: Error type.
    internal init(type: TapSDKErrorType) {
        
        self.type = type
        super.init()
    }
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case type	= "type"
	}
}

// MARK: - Error
extension TapSDKError: Error {}

