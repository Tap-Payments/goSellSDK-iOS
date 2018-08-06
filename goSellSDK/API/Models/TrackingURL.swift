//
//  TrackingURL.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Redirect model.
internal struct TrackingURL: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    internal private(set) var status: URLStatus?
    
    /// URL.
    internal private(set) var  url: URL?
    
    // MARK: Methods
    
    internal init(url: URL) {
        
        self.url = url
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case url    = "url"
    }
}
