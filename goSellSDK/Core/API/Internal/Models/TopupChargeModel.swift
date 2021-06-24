//
//  TopupChargeModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 6/24/21.
//

import Foundation
/// TopUp Charge model.
internal final class TopupChargeModel: NSObject,Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The topup charge id
    private let id: String
    
    // MARK: - Private -
    
    internal enum CodingKeys: String, CodingKey {
        
        case id             = "id"
    }
    
    // MARK: Methods
    
    init(id: String) {
        
        self.id             = id
    }
}

// MARK: - Decodable
extension TopupChargeModel {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id          = try container.decode          (String.self,           forKey: .id)
        
        self.init(id:id)
    }
}
