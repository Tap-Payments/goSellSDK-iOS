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
    
    internal required init(type: AmountModificatorType, value: Decimal, currency: Currency, minFee:Decimal = 0, maxFee:Decimal = 0) {
        
        self.currency = currency
        super.init(type: type, value: value, minFee: minFee, maxFee: maxFee)
    }
    
    internal required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(AmountModificatorType.self, forKey: .type)
        let value = try container.decode(Decimal.self, forKey: .value)
        let maxFee = try container.decodeIfPresent(Decimal.self, forKey: .maxFee) ?? 0
        let minFee = try container.decodeIfPresent(Decimal.self, forKey: .minFee) ?? 0
        let currency = try container.decode(Currency.self, forKey: .currency)
        
        self.init(type: type, value: value, currency: currency,minFee:minFee, maxFee: maxFee)
    }

    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type       = "type"
        case value      = "value"
        case currency   = "currency"
        case maxFee     = "maximum_fee"
        case minFee     = "minimum_fee"
    }
}
