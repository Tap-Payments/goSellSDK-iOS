//
//  Redirect.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Redirect model.
internal struct Redirect: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    internal private(set) var status: RedirectStatus?
    
    /// This is the payment URL that will be passed to you to forward it to your customer.
    /// This url, will contain a checkout page with all the details provided in the request's body.
    internal private(set) var paymentURL: URL?
    
    /// The URL you provide to redirect the customer to after they completed their payment.
    /// The status of the payment is either succeeded, pending, or failed.
    /// Also "payload" (charge response) will be posted to the return_url
    internal private(set) var returnURL: URL
    
    /// The URL you provide to post the charge response after completion of payment.
    /// The status of the payment is either succeeded, pending, or failed
    internal private(set) var postURL: URL?
    
    // MARK: Methods
    
    /// Initializes the redirect model with return URL and post URL
    ///
    /// - Parameters:
    ///   - returnURL: Return URL
    ///   - postURL: Post URL
    internal init(returnURL: URL, postURL: URL? = nil) {
        
        self.returnURL  = returnURL
        self.postURL    = postURL
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status     = "status"
        case paymentURL = "url"
        case returnURL  = "return_url"
        case postURL    = "post_url"
    }
}
