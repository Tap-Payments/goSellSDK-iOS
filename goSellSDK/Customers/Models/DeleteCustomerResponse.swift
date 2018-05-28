//
//  DeleteCustomerResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Response model for delete customer request.
@objcMembers public class DeleteCustomerResponse: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The ID of the deleted customer.
    public private(set) var identifier: String?
    
    /// Returns true on success.
    public private(set) var isDeleted: Bool = false
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case isDeleted = "deleted"
    }
}
