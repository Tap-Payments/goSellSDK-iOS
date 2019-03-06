//
//  ExtraFee.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Extra Fee Model.
internal final class ExtraFee: AmountModificator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency code.
    internal let currency: Currency
    
    // MARK: Methods
    
    internal required init(type: AmountModificatorType, value: Decimal, currency: Currency) {
        
        self.currency = currency
        super.init(type: type, value: value)
    }
    
    internal required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(AmountModificatorType.self, forKey: .type)
        let value = try container.decode(Decimal.self, forKey: .value)
        let currency = try container.decode(Currency.self, forKey: .currency)
        
        self.init(type: type, value: value, currency: currency)
    }

    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type       = "type"
        case value      = "value"
        case currency   = "currency"
    }
}
