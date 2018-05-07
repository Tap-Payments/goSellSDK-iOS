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
    
    internal static let hasPCIDSS = Permissions(rawValue: Set<String>([Constants.hasPCIDSSKey]))
    internal static let cardWalletEnabled = Permissions(rawValue: Set<String>([Constants.cardWalletEnabledKey]))
    
    // MARK: Methods
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let value = try container.decode(RawValue.self)
        
        self.init(rawValue: value)
    }
    
    internal init(rawValue: Set<String>) {

        var optionsStorage: Set<String> = Set<String>()

        rawValue.forEach { option in
            
            if Constants.availableOptions.contains(option) {
                
                optionsStorage.insert(option)
            }
        }
        
        self.rawValue = optionsStorage
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
        
        fileprivate static let hasPCIDSSKey = "has_pci_dss"
        fileprivate static let cardWalletEnabledKey = "card_wallet_enabled"
        
        fileprivate static let availableOptions: [String] = {
            
            return [
                
                Constants.hasPCIDSSKey,
                Constants.cardWalletEnabledKey
            ]
        }()
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    
}
