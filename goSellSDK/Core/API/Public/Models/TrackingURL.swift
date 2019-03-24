//
//  TrackingURL.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Redirect model.
@objcMembers public final class TrackingURL: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    public private(set) var status: URLStatus = .pending
    
    /// URL.
    public private(set) var url: URL?
    
    // MARK: Methods
    
    /// Initializes `TrackingURL` with the `url`.
    ///
    /// - Parameter url: URL to initialize `TrackingURL` with.
    public init(url: URL) {
        
        self.url = url
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case url    = "url"
    }
    
    // MARK: Methods
    
    private init(url: URL?, status: URLStatus) {
        
        self.url = url
        self.status = status
    }
}

// MARK: - Encodable
extension TrackingURL: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.url, forKey: .url)
    }
}

// MARK: - Decodable
extension TrackingURL: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let url = container.decodeURLIfPresent(for: .url)
        let status = try container.decodeIfPresent(URLStatus.self, forKey: .status) ?? .pending
        
        self.init(url: url, status: status)
    }
}
