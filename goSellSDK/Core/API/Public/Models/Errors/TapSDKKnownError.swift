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
    
    /// Descriptive missing keys description
    public private(set) var customDescription: String = ""
    /// Readable description of the error.
    public override var description: String {
        
        let firstLine   = super.description
        let secondLine  = self.customDescription
        let thirdLine  = "Underlying error: " + self.errorDescription
        let fourthLine   = "URL response: " + self.urlResponseDescription
		let fifthLine	= "Body: " + self.responseBodyDescription
        
        let lines: [String] = [firstLine, secondLine, thirdLine, fourthLine,fifthLine]
        
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
		
			try container.encodeIfPresent(self.error.debugDescription, forKey: .error)
		}
		
		if let urlResponseDescription = self.urlResponse?.debugDescription {
			
			try container.encodeIfPresent(urlResponseDescription, forKey: .urlResponse)
		}
		
		if
			
			let nonnullBody = self.responseBody,
			let bodyData = try? JSONSerialization.data(withJSONObject: nonnullBody, options: []),
			let bodyJSONString = String(data: bodyData, encoding: .utf8) {
			
			try container.encodeIfPresent(bodyJSONString, forKey: .responseBody)
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
	@objc public init(type: TapSDKErrorType, error: Error, response: URLResponse?, body: Any?) {
        
        super.init(type: type)
        self.error			= error
        self.urlResponse	= response
		self.responseBody	= body
        self.customDescription = "TAP SDK KNOWN ERROR : \(type.description) \n Error description : \(self.errorDescription) \(error) \n URL : \(response?.url?.absoluteString ?? "") \n Error Response Body : \(self.responseBodyDescription)\n Error URL Body : \(self.urlResponseDescription)"
        
        print(self.customDescription)
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
