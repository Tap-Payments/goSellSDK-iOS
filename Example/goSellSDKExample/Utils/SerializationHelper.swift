//
//  SerializationHelper.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Customer

internal class SerializationHelper {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func updateCustomer(_ customer: Customer, with identifier: String) {
        
        var allCustomers: [Customer] = Serializer.deserialize()
        guard let index = allCustomers.index(of: customer) else { return }
        
        customer.identifier = identifier
        
        allCustomers.remove(at: index)
        allCustomers.insert(customer, at: index)
        
        Serializer.serialize(allCustomers)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
}
