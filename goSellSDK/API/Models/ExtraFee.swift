//
//  ExtraFee.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Extra Fee Model.
internal struct ExtraFee: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Merchant identifier.
    internal private(set) var merchantIdentifier: String
    
    /// Fee value (either percents or amount based on 'fee_type').
    internal private(set) var fee: Decimal
    
    /// Fee type.
    internal private(set) var type: FeeType
    
    /// Currency code.
    internal private(set) var currency: Currency
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case merchantIdentifier = "merchant_id"
        case fee = "fee"
        case type = "fee_type"
        case currency = "currency_code"
    }
}
