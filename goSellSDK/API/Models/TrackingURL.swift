//
//  TrackingURL.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Redirect model.
@objcMembers public final class TrackingURL: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    public private(set) var status: URLStatus = .pending
    
    /// URL.
    public private(set) var  url: URL?
    
    // MARK: Methods
    
    public init(url: URL) {
        
        self.url = url
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case url    = "url"
    }
}
