//
//  SerializationHelper.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class goSellSDK.Customer

internal class SerializationHelper {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func updateCustomer(_ customer: Customer, with identifier: String) -> EnvironmentCustomer? {
        
        var allCustomers: [EnvironmentCustomer] = Serializer.deserialize()
        guard let index = allCustomers.firstIndex(where: { $0.customer == customer }) else { return nil }
    
        let envCustomer = allCustomers[index]
        envCustomer.customer.identifier = identifier
        
        allCustomers.remove(at: index)
        allCustomers.insert(envCustomer, at: index)
        
        Serializer.serialize(allCustomers)
        
        return envCustomer
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    //@available(*, unavailable) private init() {}
}
