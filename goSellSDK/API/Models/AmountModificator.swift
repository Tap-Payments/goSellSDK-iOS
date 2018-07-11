//
//  AmountModificator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Amount modificator class, used for taxes and doscount models.
@objcMembers public class AmountModificator: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Amount modificator type.
    public var type: AmountModificatorType
    
    /// Value.
    public var value: Decimal
    
    // MARK: Methods
    
    /// Initializes amount modificator with modification type and value.
    ///
    /// - Parameters:
    ///   - type: Modification type.
    ///   - value: Modification value.
    public init(type: AmountModificatorType, value: Decimal) {
        
        self.type = type
        self.value = value
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var normalizedValue: Decimal {
        
        guard self.type == .percents else {
            
            fatalError("normalizedValue should never be called on \(AmountModificator.className) if it's type is not percentBased")
        }
        
        return 0.01 * self.value
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case value  = "value"
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
