//
//  TapSDKKnownError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Known error. Either network or serialization error.
@objcMembers public final class TapSDKKnownError: TapSDKError {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// URL response (if received) which will help the developer to understand the issue.
    public private(set) var urlResponse: URLResponse?
	
	/// Response body (if any).
	public private(set) var responseBody: Any?
    
    /// Underlying error.
    public private(set) var error: Error?
    
    /// Readable description of the error.
    public override var description: String {
        
        let firstLine   = super.description
        let secondLine  = "Underlying error: " + self.errorDescription
        let thirdLine   = "URL response: " + self.urlResponseDescription
		let fourthLine	= "Body: " + self.responseBodyDescription
        
        let lines: [String] = [firstLine, secondLine, thirdLine, fourthLine]
        
        return lines.joined(separator: "\n")
    }
	
	// MARK: Methods
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
	public override func encode(to encoder: Encoder) throws {
		
		try super.encode(to: encoder)
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		if self.error != nil {
		
			try container.encode(self.error.debugDescription, forKey: .error)
		}
		
		if let urlResponseDescription = self.urlResponse?.debugDescription {
			
			try container.encode(urlResponseDescription, forKey: .urlResponse)
		}
		
		if
			
			let nonnullBody = self.responseBody,
			let bodyData = try? JSONSerialization.data(withJSONObject: nonnullBody, options: []),
			let bodyJSONString = String(data: bodyData, encoding: .utf8) {
			
			try container.encode(bodyJSONString, forKey: .responseBody)
		}
	}
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the error with type, underlying error and URL response.
    ///
    /// - Parameters:
    ///   - type: Error type.
    ///   - error: Underlying error.
    ///   - response: URL response.
	internal init(type: TapSDKErrorType, error: Error?, response: URLResponse?, body: Any?) {
        
        super.init(type: type)
		
        self.error			= error
        self.urlResponse	= response
		self.responseBody	= body
    }
    
    // MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case error			= "error"
		case urlResponse	= "url_response"
		case responseBody	= "response_body"
	}
	
    // MARK: Properties
    
    private var errorDescription: String {
        
        if let nonnullError = self.error {
            
            return nonnullError.localizedDescription
        }
        else {
            
            return "nil"
        }
    }
    
    private var urlResponseDescription: String {
        
        if let nonnullResponse = self.urlResponse {
            
            return nonnullResponse.description
        }
        else {
            
            return "nil"
        }
    }
	
	private var responseBodyDescription: String {
		
		if let nonnullBody = self.responseBody {
			
			return "\(nonnullBody)"
		}
		else {
			
			return "nil"
		}
	}
}
