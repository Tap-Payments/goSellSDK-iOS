//
//  PaymentOption.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand
import struct PassKit.PKPaymentNetwork

/// Payment Option model.
internal struct PaymentOption: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    internal let identifier: String
    
    /// Payment option card brand.
    internal let brand: CardBrand
    
    /// Name of the payment option.
    internal let title: String
    
    /// Image URL of the payment option.
    internal let imageURL: URL
    
    /// If the payment option is async or not
    internal let isAsync: Bool
    
    /// Payment type.
    internal let paymentType: PaymentType
    
    /// Source identifier.
    internal private(set) var sourceIdentifier: String?
    
    /// Supported card brands.
    internal let supportedCardBrands: [CardBrand]
    
    /// Extra fees.
    internal private(set) var extraFees: [ExtraFee]
    
    /// List of supported currencies.
    internal let supportedCurrencies: [Currency]
    
    /// Ordering parameter.
    internal let orderBy: Int
    
    /// Decide if the 3ds should be disabled, enabled or set by user for this payment option
    internal let threeDLevel: ThreeDSecurityState
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case title                  = "name"
        case imageURL               = "image"
        case paymentType            = "payment_type"
        case sourceIdentifier       = "source_id"
        case supportedCardBrands    = "supported_card_brands"
        case extraFees              = "extra_fees"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
        case isAsync                = "asynchronous"
        case threeDLevel            = "threeDS"
    }
    
    internal func applePayNetworkMapper() -> [PKPaymentNetwork]
    {
        var applePayMappednNetworks:[PKPaymentNetwork] = []
        
        // Check if the original brand is in the supported, otherwise add it to the list we need to search
        var toBeCheckedCardBrands:[CardBrand] = supportedCardBrands
        
        if !toBeCheckedCardBrands.contains(brand)
        {
            toBeCheckedCardBrands.insert(brand, at: 0)
        }
        for cardBrand:CardBrand in toBeCheckedCardBrands
        {
            if cardBrand == .visa
            {
                applePayMappednNetworks.append(PKPaymentNetwork.visa)
            }else if cardBrand == .masterCard
            {
                applePayMappednNetworks.append(PKPaymentNetwork.masterCard)
            }else if cardBrand == .americanExpress
            {
                applePayMappednNetworks.append(PKPaymentNetwork.amex)
            }else if cardBrand == .maestro
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.maestro)
                }
            }else if cardBrand == .visaElectron
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.electron)
                }
            }else if cardBrand == .mada
            {
                if #available(iOS 12.1.1, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.mada)
                }
            }
        }
        
        return applePayMappednNetworks.removingDuplicates()
    }
    
    private static func mapThreeDLevel(with threeD:String) -> ThreeDSecurityState
    {
        if threeD.lowercased() == "n"
        {
            return .never
        }else if threeD.lowercased() == "y"
        {
            return .always
        }else
        {
            return .definedByMerchant
        }
    }
}

// MARK: - Decodable
extension PaymentOption: Decodable {

    internal init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)

        let identifier          = try container.decode          (String.self,       forKey: .identifier)
        let brand               = try container.decode          (CardBrand.self,    forKey: .title)
        let title               = try container.decode          (String.self,       forKey: .title)
        let imageURL            = try container.decode          (URL.self,          forKey: .imageURL)
		let paymentType         = try container.decode          (PaymentType.self,  forKey: .paymentType)
        let sourceIdentifier    = try container.decodeIfPresent (String.self,       forKey: .sourceIdentifier)
        var supportedCardBrands = try container.decode          ([CardBrand].self,  forKey: .supportedCardBrands)
        let extraFees           = try container.decodeIfPresent ([ExtraFee].self,   forKey: .extraFees) ?? []
        let supportedCurrencies = try container.decode          ([Currency].self,   forKey: .supportedCurrencies)
        let orderBy             = try container.decode          (Int.self,          forKey: .orderBy)
        let isAsync             = try container.decode          (Bool.self,         forKey: .isAsync)
        let threeDLevel         = try container.decodeIfPresent (String.self,       forKey: .threeDLevel) ?? "U"
		
		supportedCardBrands = supportedCardBrands.filter { $0 != .unknown }
		
        self.init(identifier: identifier,
                  brand: brand,
                  title: title,
                  imageURL: imageURL,
                  isAsync: isAsync, paymentType: paymentType,
                  sourceIdentifier: sourceIdentifier,
                  supportedCardBrands: supportedCardBrands,
                  extraFees: extraFees,
                  supportedCurrencies: supportedCurrencies,
                  orderBy: orderBy,
                  threeDLevel: PaymentOption.mapThreeDLevel(with: threeDLevel))
    }
}

extension PaymentOption
{
    internal enum ThreeDSecurityState {
        
        case always
        case never
        case definedByMerchant
    }
}

// MARK: - FilterableByCurrency
extension PaymentOption: FilterableByCurrency {}

// MARK: - SortableByOrder
extension PaymentOption: SortableByOrder {}

// MARK: - Equatable
extension PaymentOption: Equatable {
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: PaymentOption, rhs: PaymentOption) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
