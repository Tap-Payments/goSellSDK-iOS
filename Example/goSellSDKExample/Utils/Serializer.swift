//
//  Serializer.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/27/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSData.Data
import class Foundation.NSJSONSerialization.JSONSerialization
import class Foundation.NSUserDefaults.UserDefaults
import class goSellSDK.PaymentItem

internal class Serializer {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func serialize(_ items: [PaymentItem]) {
        
        let arrayOfDictionaries = items.compactMap { $0.dictionaryRepresentation }
        guard arrayOfDictionaries.count > 0 else { return }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: arrayOfDictionaries, options: []) else { return }
        UserDefaults.standard.set(jsonData, forKey: Constants.itemsUserDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    internal static func deserializeItems() -> [PaymentItem] {
        
        guard let jsonData = UserDefaults.standard.object(forKey: Constants.itemsUserDefaultsKey) as? Data else { return [] }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
        guard let arrayOfDictionariesObject = jsonObject as? [[String: Any]] else { return [] }
        
        let items = arrayOfDictionariesObject.compactMap { PaymentItem(dictionaryRepresentation: $0) }
        return items
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let itemsUserDefaultsKey = "goSellSDKExample.items"
        
        @available(*, unavailable) private init() {}
    }
}
