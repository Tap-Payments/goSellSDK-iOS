//
//  TopUp.swift
//  goSellSDK
//
//  Created by Osama Rabie on 6/21/21.
//

import Foundation

/// Wallet Topup model.
@objcMembers public final class Topup: NSObject {
    
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The wallet id you want to topup
    public let walletID: String
    
    /// The topup transaction reference
    public let reference: Reference?
    
    /// The topup transaction amount details
    public let application: TopUpApplication?
    
    /// The topup transaction any additional meta data you want to keep
    public let metdata: Metadata?
    
    /// The topup's id
    internal let id: String?
    
    /// The topup's id
    internal let created: Decimal?
    
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    internal var amount: Decimal?
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    internal var currency: Currency?
    
    /// The topup charge
    internal let charge: TopupChargeModel?
    
    /// The topup customer model
    internal let customer: Customer?
    
    /// The topup status
    internal let status: String?
    
    /// The topup response code and message
    internal let response: Response?
    
    /// The topup post url
    public private(set) var post: TrackingURL?
    
    
    // MARK: Methods
    
    /// Initializes `Topup`.
    ///
    /// - Parameter walletID: The wallet id you want to topup
    /// - Parameter reference: The topup transaction reference
    /// - Parameter application: The topup transaction amount details
    /// - Parameter metdata: The topup transaction any additional meta data you want to keep
    public init(walletID: String, reference: Reference?, application: TopUpApplication?, metdata: Metadata?,post:TrackingURL? = nil) {
        self.walletID = walletID
        self.reference = reference
        self.application = application
        self.metdata = metdata
        self.post = post
        self.id = nil
        self.created = 0
        self.charge = nil
        self.amount = Process.shared.externalSession?.dataSource?.amount ?? 0
        self.customer = nil
        self.currency = Process.shared.externalSession?.dataSource?.currency ?? nil
        self.status = nil
        self.response = nil
    }
    
    
    internal init(walletID: String, reference: Reference?, application: TopUpApplication?, metdata: Metadata?,id:String? = nil,created:Decimal? = 0,amount:Decimal?=0, currency:Currency? = nil, charge:TopupChargeModel? = nil, customer:Customer? = nil, status:String? = nil, response:Response? = nil, post:TrackingURL? = nil) {
        self.walletID = walletID
        self.reference = reference
        self.application = application
        self.metdata = metdata
        self.id = id
        self.created = created
        self.charge = charge
        self.amount = amount
        self.customer = customer
        self.currency = currency
        self.status = status
        self.response = response
        self.post = post
    }
    
    // MARK: - Private -

    private enum CodingKeys: String, CodingKey {
        
        case walletID       = "wallet_id"
        case reference      = "reference"
        case application    = "application"
        case metdata        = "metdata"
        case id             = "id"
        case amount         = "amount"
        case created        = "created"
        case charge         = "charge"
        case customer       = "customer"
        case currency       = "currency"
        case status         = "status"
        case response       = "response"
        case post           = "post"
    }
    
    // MARK: Methods
    
   
}

// MARK: - Encodable
extension Topup: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.walletID, forKey: .walletID)
        try container.encodeIfPresent(self.reference, forKey: .reference)
        try container.encodeIfPresent(self.application, forKey: .application)
        try container.encodeIfPresent(self.metdata, forKey: .metdata)
        
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.amount, forKey: .amount)
        try container.encodeIfPresent(self.created, forKey: .created)
        try container.encodeIfPresent(self.charge, forKey: .charge)
        try container.encodeIfPresent(self.customer, forKey: .customer)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.post, forKey: .post)
        //try container.encodeIfPresent(self.response, forKey: .response)
    }
}

// MARK: - Decodable
extension Topup: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let walletID        = try container.decode              (String.self,           forKey: .walletID)
        let reference       = try container.decodeIfPresent     (Reference.self,        forKey: .reference)
        let application     = try container.decodeIfPresent               (TopUpApplication.self, forKey: .application)
        let metadata        = try container.decodeIfPresent      (Metadata.self,         forKey: .metdata)
        let id              = try container.decodeIfPresent      (String.self,         forKey: .id)
        let status          = try container.decodeIfPresent      (String.self,         forKey: .status)
        let amount          = try container.decodeIfPresent      (Decimal.self,         forKey: .amount)
        let created         = try container.decodeIfPresent      (Decimal.self,         forKey: .created)
        let charge          = try container.decodeIfPresent      (TopupChargeModel.self,         forKey: .charge)
        let customer        = try container.decodeIfPresent      (Customer.self,         forKey: .customer)
        let currency        = try container.decodeIfPresent      (Currency.self,         forKey: .currency)
        let response        = try container.decodeIfPresent      (Response.self,         forKey: .response)
        let post            = try container.decodeIfPresent          (TrackingURL.self,         forKey: .post)
        
        self.init(walletID: walletID, reference: reference, application: application, metdata: metadata,id: id, created: created, amount: amount, currency: currency, charge: charge, customer: customer,status: status, response: response, post: post)
    }
}
