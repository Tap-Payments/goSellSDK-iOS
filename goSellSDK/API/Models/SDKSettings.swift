//
//  SDKSettings.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// goSell SDK Settings model.
internal class SDKSettings: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Data.
    internal var data: SDKSettingsData?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
}
