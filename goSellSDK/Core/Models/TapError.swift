//
//  TapError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Foundation.NSObject.NSObject
import class Foundation.NSURLResponse.URLResponse
import class Foundation.NSURLSession.URLSessionDataTask

// MARK: - TapSerializationError -

/// Serialization error.
///
/// - wrongData: Wrong data to serialize/deserialize.
public enum TapSerializationError: Int, Error {
    
    /// Wrong data to serialize/deserialize.
    case wrongData
}

// MARK: - TAPSDKErrorType -

/// Enum describing error type.
///
/// - api: API error.
/// - network: Network error.
/// - serialization: Serialization error.
/// - unknown: Unknown error.
public enum TAPSDKErrorType: Int {
    
    /// API error.
    case api
    
    /// Network error.
    case network
    
    /// Serialization error.
    case serialization
    
    /// Unknown error.
    case unknown
    
    /// Readable error type.
    internal var readableType: String {
        
        switch self {
            
        case .api: return "API"
        case .network: return "Network"
        case .serialization: return "Serialization"
        case .unknown: return "Unknown"
        }
    }
}

// MARK: - TapSDKError -

/// Base abstract class for errors.
@objcMembers public class TapSDKError: NSObject {
    
    /// Error type.
    public private(set) var type: TAPSDKErrorType = .unknown
    
    /// Designated initializer for the errors.
    ///
    /// - Parameter type: Error type.
    internal init(type: TAPSDKErrorType) {
        
        self.type = type
        super.init()
    }
}

// MARK: - TapSDKKnownError -

/// Known error. Either network or serialization error.
@objcMembers public class TapSDKKnownError: TapSDKError {
    
    /// URL response (if received) which will help the developer to understand the issue.
    public private(set) var urlResponse: URLResponse?
    
    /// Underlying error.
    public private(set) var error: Error?
    
    /// Readable description of the error.
    public override var description: String {
     
        let errorDescription = self.error == nil ? "nil" : "\(self.error!)"
        let urlResponseDescription = self.urlResponse?.description ?? "nil"
        return "\(self.type.readableType) error has occured.\nUnderlying error: \(errorDescription)\nURL response: \(urlResponseDescription)"
    }
    
    /// Initializes the error with type, underlying error and URL response.
    ///
    /// - Parameters:
    ///   - type: Error type.
    ///   - error: Underlying error.
    ///   - response: URL response.
    internal init(type: TAPSDKErrorType, error: Error?, response: URLResponse?) {
        
        super.init(type: type)
        self.error = error
        self.urlResponse = response
    }
}

// MARK: - TapSDKAPIError -

/// API error.
@objcMembers public class TapSDKAPIError: TapSDKError {
    
    /// Underlying API error (parsed error from the backend).
    public private(set) var error: APIError

    /// URL response.
    public private(set) var urlResponse: URLResponse?
    
    /// Readable description of the error.
    public override var description: String {
     
        let urlResponseDescription = urlResponse?.description ?? "nil"
        return "API error has occured.\nError: \(error.description)\nURL response: \(urlResponseDescription)"
    }
    
    /// Initializes the error with parsed error from the backend and URL response.
    ///
    /// - Parameters:
    ///   - error: Error.
    ///   - response: URL response.
    internal init(error: APIError, response: URLResponse?) {
        
        self.error = error
        self.urlResponse = response
        super.init(type: .api)
    }
}

// MARK: - TapSDKUnknownError -

/// Unknown or unhandled error.
@objcMembers public class TapSDKUnknownError: TapSDKError {
    
    /// Data task to understand what is going on. If data task is nil that means that request hasn't even started.
    public private(set) var dataTask: URLSessionDataTask?
    
    /// Readable description of the error.
    public override var description: String {
        
        let dataTaskDescription = dataTask?.description ?? "nil"
        return "Unknown error. Data task: \(dataTaskDescription)"
    }
    
    /// Initializes an error with data task.
    ///
    /// - Parameter dataTask: Data task.
    internal init(dataTask: URLSessionDataTask?) {
        
        super.init(type: .unknown)
        self.dataTask = dataTask
    }
}

// MARK: - APIError -

/// Structure representing API error.
@objcMembers public class APIError: NSObject, Decodable {
    
    /// Error details.
    public var details: [ErrorDetail] = []
    
    /// Readable description of the error.
    public override var description: String {
        
        guard self.details.count > 0 else {
            
            return "Backend responded with empty response."
        }
        
        var result = "\nErrors detected on the backend:\n"
        let longestErrorTitleLength = (self.details.map { $0.name.count }).max()!
        
        for error in self.details {
            
            let extraWhitespaces = String(repeating: " ", count: longestErrorTitleLength - error.name.count)
            result += error.name + ": " + extraWhitespaces + error.message + "\n"
        }
        
        return result
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case details = "errors"
    }
}

// MARK: - ErrorDetail -

/// Error detail model.
@objcMembers public class ErrorDetail: NSObject, Decodable {
    
    /// Error name.
    public private(set) var name: String = ""
    
    /// Error message.
    public private(set) var message: String = ""
    
    private enum CodingKeys: String, CodingKey {
        
        case name = "fieldname"
        case message
    }
}
