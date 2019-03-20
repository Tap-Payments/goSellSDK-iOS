//
//  Tax.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Tax data model.
@objcMembers public final class Tax: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Tax title.
    public var title: String
    
    /// Tax description.
    public var descriptionText: String?
    
    /// Tax amount.
    public var amount: AmountModificator
    
    // MARK: Methods
    
    /// Initializes `Tax` with `title` and `amount`.
    ///
    /// - Parameters:
    ///   - title: Tax title.
    ///   - amount: Tax amount.
    public convenience init(title: String, amount: AmountModificator) {
        
        self.init(title: title, descriptionText: nil, amount: amount)
    }
    
    /// Initializes `Tax` with `title`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - title: Tax title.
    ///   - descriptionText: Tax description.
    ///   - amount: Tax amount.
    public required init(title: String, descriptionText: String?, amount: AmountModificator) {
        
        self.title = title
        self.amount = amount
        self.descriptionText = descriptionText
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case title              = "name"
        case descriptionText    = "description"
        case amount             = "amount"
    }
}

// MARK: - NSCopying
extension Tax: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let amountCopy = self.amount.copy() as! AmountModificator
        
        return Tax(title: self.title, descriptionText: self.descriptionText, amount: amountCopy)
    }
}
