//
//  Permissions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Permissions option set.
internal struct Permissions: OptionSet, Decodable {
    
    // MARK: - Internal -
    
    internal var rawValue: Set<String>
    
    // MARK: Properties
    
    internal static let pci                 = Permissions(rawValue: Set<String>([Constants.pciKey]))
    internal static let merchantCheckout    = Permissions(rawValue: Set<String>([Constants.merchantCheckoutKey]))
    
    // MARK: Methods
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let value = try container.decode(RawValue.self)
        
        self.init(rawValue: value)
    }
    
    internal init(rawValue: Set<String>) {

        self.rawValue = rawValue.filter { Constants.availableOptions.contains($0) }
    }
    
    internal init() {

        self.rawValue = Set<String>()
    }

    internal mutating func formUnion(_ other: Permissions) {

        self.rawValue.formUnion(other.rawValue)
    }

    internal mutating func formIntersection(_ other: Permissions) {

        self.rawValue.formIntersection(other.rawValue)
    }

    internal mutating func formSymmetricDifference(_ other: Permissions) {

        self.rawValue.formSymmetricDifference(other.rawValue)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let pciKey               = "pci"
        fileprivate static let merchantCheckoutKey  = "merchant_checkout"
        
        fileprivate static let availableOptions: [String] = {
            
            return [
                
                Constants.pciKey,
                Constants.merchantCheckoutKey
            ]
        }()
        
        @available(*, unavailable) private init() {}
    }
}
