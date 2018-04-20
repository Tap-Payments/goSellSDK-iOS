//
//  Redirect.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Redirect model.
internal class Redirect: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The status of the payment is either succeeded, pending, or failed.
    internal private(set) var status: String?
    
    /// This is the payment URL that will be passed to you to forward it to your customer.
    /// This url, will contain a checkout page with all the details provided in the request's body.
    internal private(set) var url: URL?
    
    /// The URL you provide to redirect the customer to after they completed their payment.
    /// The status of the payment is either succeeded, pending, or failed.
    /// Also "payload" (charge response) will be posted to the return_url
    internal var returnURL: URL?
    
    /// The URL you provide to post the charge response after completion of payment.
    /// The status of the payment is either succeeded, pending, or failed
    internal var postURL: URL?
    
    // MARK: Methods
    
    /// Initializes the redirect model with return URL and post URL
    ///
    /// - Parameters:
    ///   - returnURL: Return URL
    ///   - postURL: Post URL
    internal init(returnURL: URL, postURL: URL? = nil) {
        
        self.returnURL = returnURL
        self.postURL = postURL
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case url = "url"
        case returnURL = "return_url"
        case postURL = "post_url"
    }
}

// MARK: - CustomStringConvertible
extension Redirect: CustomStringConvertible {
    
    /// Pretty printed description of the ChargeRedirect object.
    internal var description: String {
        
        let lines: [String] = [
            
            "Redirect",
            "status:     \(self.status?.description ?? "nil")",
            "url:        \(self.url?.description ?? "nil")",
            "return url: \(self.returnURL?.description ?? "nil")",
            "post url:   \(self.postURL?.description ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
}
