//
//  TransactionExpiry.swift
//  EditableTextInsetsTextField
//
//  Created by Osama Rabie on 06/02/2020.
//

@objcMembers public final class TransactionOrder: NSObject{
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Order reference by merchant
    public let reference: String
	/// Merchant's more info url
    public let storeUrl: String
    
    // MARK: Methods
    
    /// Initializes order object with order  number and merchant's info
    ///
    /// - Parameters:
    ///   - reference: Order reference number provided by Merchant
    ///   - storeUrl: Url to show more info about  the order on the Merchant side
    public init(reference: String, storeUrl: String) {
        
        self.reference = reference
        self.storeUrl = storeUrl
        
        super.init()
    }
    
    // MARK: - Private
    
    private enum CodingKeys: String, CodingKey {
        
        case reference  = "reference"
        case storeUrl   = "store_url"
    }
}

// MARK: - Decodable
extension TransactionOrder: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let reference        = try container.decode 			(String.self,   forKey: .reference)
        let storeUrl      	 = try container.decode          	(String.self,   forKey: .storeUrl)
        
        self.init(reference: reference, storeUrl: storeUrl)
    }
}


