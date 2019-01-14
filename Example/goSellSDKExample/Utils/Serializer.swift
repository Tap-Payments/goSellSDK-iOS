//
//  Serializer.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   Foundation.NSData.Data
import class    Foundation.NSJSONSerialization.JSONSerialization
import class    Foundation.NSUserDefaults.UserDefaults
import class    goSellSDK.Customer
import class    goSellSDK.PaymentItem

internal class Serializer {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func serialize<T: Encodable>(_ object: T) {
        
        guard let key = self.key(for: T.self) else { return }
        guard let dictionary = object.dictionaryRepresentation else { return }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return }
        
        UserDefaults.standard.set(jsonData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    internal static func deserialize<T: Decodable>() -> T? {
        
        guard let key = self.key(for: T.self) else { return nil }
        
        guard let jsonData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
        guard let dictionaryObject = jsonObject as? DictionaryType else { return nil }
        
        let object = T(dictionaryRepresentation: dictionaryObject)
        return object
    }
    
    internal static func serialize<T: Encodable>(_ objects: [T]) {
        
        guard let key = self.key(for: T.self, isArray: true) else { return }
        
        let arrayOfDictionaries = objects.compactMap { $0.dictionaryRepresentation }
        guard arrayOfDictionaries.count > 0 else { return }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: arrayOfDictionaries, options: []) else { return }
        
        UserDefaults.standard.set(jsonData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    internal static func deserialize<T: Decodable>() -> [T] {
        
        guard let key = self.key(for: T.self, isArray: true) else { return [] }
        
        guard let jsonData = UserDefaults.standard.object(forKey: key) as? Data else { return [] }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
        guard let arrayOfDictionariesObject = jsonObject as? ArrayOfDictionariesType else { return [] }
        
        let objects = arrayOfDictionariesObject.compactMap { T(dictionaryRepresentation: $0) }
        return objects
    }
    
    internal static func markAllCustomersAsSandboxIfNotYet() {
        
        guard !UserDefaults.standard.bool(forKey: Constants.didMakeSandboxCustomersUserDefaultsKey) else { return }
        
        let oldCustomers: [Customer] = self.deserialize()
        let newCustomers = oldCustomers.map { EnvironmentCustomer(customer: $0, environment: .sandbox) }
        
        self.serialize(newCustomers)
        
        if let customersKey = self.key(for: Customer.self, isArray: true) {
            
            UserDefaults.standard.removeObject(forKey: customersKey)
        }
        
        if let oldCustomer: Customer = self.deserialize() {
            
            let newCustomer = EnvironmentCustomer(customer: oldCustomer, environment: .sandbox)
            self.serialize(newCustomer)
            
            if let customerKey = self.key(for: Customer.self) {
                
                UserDefaults.standard.removeObject(forKey: customerKey)
            }
        }
        
        UserDefaults.standard.set(true, forKey: Constants.didMakeSandboxCustomersUserDefaultsKey)
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let itemsUserDefaultsKey                     = Constants.keyPrefix + "item"
        fileprivate static let customersUserDefaultsKey                 = Constants.keyPrefix + "customer"
        fileprivate static let environmentCustomerUserDefaultsKey       = Constants.keyPrefix + "environment_customer"
        fileprivate static let settingsUserDefaultsKey                  = Constants.keyPrefix + "settings"
        fileprivate static let didMakeSandboxCustomersUserDefaultsKey   = Constants.keyPrefix + "did_make_sandbox_customers"
        
        fileprivate static let multipleSuffix   = "s"
        
        private static let keyPrefix            = "goSellSDKExample."
        
        
        @available(*, unavailable) private init() {}
    }
    
    private typealias DictionaryType            = [String: Any]
    private typealias ArrayOfDictionariesType   = [DictionaryType]
    
    // MARK: Methods
    
    private static func key<T>(for modelType: T.Type, isArray: Bool = false) -> String? {
        
        var result: String?
        
        if modelType == PaymentItem.self {
            
            result = Constants.itemsUserDefaultsKey
        }
        else if modelType == Customer.self {
            
            result = Constants.customersUserDefaultsKey
        }
        else if modelType == Settings.self {
            
            result = Constants.settingsUserDefaultsKey
        }
        else if modelType == EnvironmentCustomer.self {
            
            result = Constants.environmentCustomerUserDefaultsKey
        }
        else {
            
            result = nil
        }
        
        guard var nonnullResult = result else { return nil }
        
        if isArray {
            
            nonnullResult += Constants.multipleSuffix
        }
        
        return nonnullResult
    }
}
