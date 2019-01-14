//
//  EnvironmentCustomer.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol Foundation.NSObject.NSCopying
import class    goSellSDK.Customer
import enum     goSellSDK.SDKMode
import struct   ObjectiveC.NSZone

internal class EnvironmentCustomer: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let customer: Customer
    internal var environment: SDKMode
    
    // MARK: Methods
    
    internal init(customer: Customer, environment: SDKMode) {
        
        self.customer = customer
        self.environment = environment
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case customer       = "customer"
        case environment    = "environment"
    }
}

// MARK: - Equatable
extension EnvironmentCustomer: Equatable {
    
    internal static func == (lhs: EnvironmentCustomer, rhs: EnvironmentCustomer) -> Bool {
        
        return lhs.environment == rhs.environment && lhs.customer == rhs.customer
    }
}

// MARK: - NSCopying
extension EnvironmentCustomer: NSCopying {
    
    internal func copy(with zone: NSZone? = nil) -> Any {
        
        if let copiedCustomer = self.customer.copy(with: zone) as? Customer {
            
            return EnvironmentCustomer(customer:copiedCustomer, environment: self.environment)
        }
        
        return self
    }
}
