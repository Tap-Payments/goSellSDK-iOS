//
//  BillingAddressResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Billing Address API Response model.
internal struct BillingAddressResponse {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Possible address formats.
    internal let formats: [BillingAddressFormat]
    
    /// Country formats.
    internal let countryFormats: [Country: AddressFormat]
    
    /// Possible address fields.
    internal let fields: [AddressField]
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case formats        = "formats"
        case countryFormats = "country_formats"
        case fields         = "fields"
    }
}

// MARK: - Decodable
extension BillingAddressResponse: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let formats = try container.decode([BillingAddressFormat].self, forKey: .formats)
        
        var countryFormats: [Country: AddressFormat] = [:]
        let countryFormatsDictionary = try container.decode([String: String].self, forKey: .countryFormats)
        countryFormatsDictionary.forEach {
            
            if let country = try? Country($0.key), let format = AddressFormat(rawValue: $0.value) {
                
                countryFormats[country] = format
            }
        }
        
        let fields = try container.decode([AddressField].self, forKey: .fields)
        
        self.init(formats: formats, countryFormats: countryFormats, fields: fields)
    }
}
