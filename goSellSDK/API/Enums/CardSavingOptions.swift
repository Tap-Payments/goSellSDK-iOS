//
//  CardSavingOptions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct CardSavingOptions: OptionSet, Encodable {
    
    // MARK: - Internal -
    
    internal var rawValue: Set<String>
    
    // MARK: Properties
    
    internal static let withMerchant = CardSavingOptions(rawValue: Set<String>([Constants.merchantKey]))
    
    // MARK: Methods
    
    internal init() {
        
        self.rawValue = Set<String>()
    }
    
    internal init(rawValue: Set<String>) {
        
        self.rawValue = rawValue.filter { Constants.availableOptions.contains($0) }
    }
    
    internal mutating func formUnion(_ other: CardSavingOptions) {
        
        self.rawValue.formUnion(other.rawValue)
    }
    
    internal mutating func formIntersection(_ other: CardSavingOptions) {
        
        self.rawValue.formIntersection(other.rawValue)
    }
    
    internal mutating func formSymmetricDifference(_ other: CardSavingOptions) {
        
        self.rawValue.formSymmetricDifference(other.rawValue)
    }
    
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let merchantKey  = "merchant"
        
        fileprivate static let availableOptions: [String] = [
        
            Constants.merchantKey
        ]
        
        @available(*, unavailable) private init() {}
    }
}
