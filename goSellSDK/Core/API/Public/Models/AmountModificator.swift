//
//  AmountModificator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Amount modificator class, used for taxes and doscount models.
@objcMembers public class AmountModificator: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Amount modificator type.
    public var type: AmountModificatorType
    
    /// Value.
    public var value: Decimal
    
    /// The minimum fees allowed for this extra fees.
    public var minFee: Decimal
    
    /// The maximum fees allowed for this extra fees.
    public var maxFee: Decimal
    
    // MARK: Methods
    
    /// Initializes amount modificator with modification type and value.
    ///
    /// - Parameters:
    ///   - type: Modification type.
    ///   - value: Modification value.
    public init(type: AmountModificatorType, value: Decimal, minFee: Decimal = 0, maxFee: Decimal = 0) {
        
        self.type = type
        self.value = value
        self.maxFee = maxFee
        self.minFee = minFee
        super.init()
        
        //applyMinMaxFees()
        
    }
    
    
    /// This method adjusts the vale of the extra fees to be within the range of Min - Max fees
    public func applyMinMaxFees() {
        
        if self.minFee > 0 && self.value < self.minFee
        {
            self.value = self.minFee
        }
        if self.maxFee > 0 && self.value > self.maxFee
        {
            self.value = self.maxFee
        }
    }
    
    /// Initializes percent based amount modification.
    ///
    /// - Parameter percents: Number of percents.
    public convenience init(percents: Decimal) {
        
        self.init(type: .percents, value: percents)
    }
    
    /// Initializes fixed amount modification.
    ///
    /// - Parameter fixedAmount: Fixed amount.
    public convenience init(fixedAmount: Decimal) {
        
        self.init(type: .fixedAmount, value: fixedAmount)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var normalizedValue: Decimal {
        
        guard self.type == .percents else {
            
            fatalError("normalizedValue should never be called on \(AmountModificator.tap_className) if it's type is not percentBased")
        }
        
        return 0.01 * self.value
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type       = "type"
        case value      = "value"
        case maxFee     = "maximum_fee"
        case minFee     = "minimum_fee"
    }
}

// MARK: - NSCopying
extension AmountModificator: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return AmountModificator(type: self.type, value: self.value)
    }
}
