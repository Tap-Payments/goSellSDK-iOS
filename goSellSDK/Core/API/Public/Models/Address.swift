//
//  Address.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Address model.
@objcMembers public final class Address: Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Address type.
    public internal(set) var type: AddressType?
    
    /// Country.
    public internal(set) var country: Country?
    
    /// Address line 1.
    public internal(set) var line1: String?
    
    /// Address line 2.
    public internal(set) var line2: String?
    
    /// Address city.
    public internal(set) var city: String?
    
    /// Address state.
    public internal(set) var state: String?
    
    /// Address zip code.
    public internal(set) var zipCode: String?
    
    /// Address country governorate.
    public internal(set) var countryGovernorate: String?
    
    /// Address area.
    public internal(set) var area: String?
    
    /// Address block.
    public internal(set) var block: String?
    
    /// Address avenue.
    public internal(set) var avenue: String?
    
    /// Address street.
    public internal(set) var street: String?
    
    /// Address building or house.
    public internal(set) var buildingHouse: String?
    
    /// Address floor.
    public internal(set) var floor: String?
    
    /// Address office.
    public internal(set) var office: String?
    
    /// Address postal box.
    public internal(set) var postalBox: String?
    
    /// Address postal code.
    public internal(set) var postalCode: String?
    
    // MARK: - Internal -
	
	internal enum CodingKeys: String, CodingKey {
		
		case format             = "format"
		case type               = "type"
		case country            = "country"
		case line1              = "line1"
		case line2              = "line2"
		case city               = "city"
		case state              = "state"
		case zipCode            = "zip_code"
		case countryGovernorate = "country_governorate"
		case area               = "area"
		case block              = "block"
		case avenue             = "avenue"
		case street             = "street"
		case buildingHouse      = "building_house"
		case floor              = "floor"
		case office             = "office"
		case postalBox          = "po_box"
		case postalCode         = "postal_code"
	}
	
	// MARK: Properties
	
	/// Address format.
	internal var format: AddressFormat?
	
    // MARK: Methods
    
    internal init(format: AddressFormat) {
        
        self.format = format
    }
}

// MARK: - Encodable
extension Address: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode            (self.format,               forKey: .format)
        
        try container.encodeIfPresent   (self.type,                 forKey: .type)
        try container.encodeIfPresent   (self.country,              forKey: .country)
        try container.encodeIfPresent   (self.line1,                forKey: .line1)
        try container.encodeIfPresent   (self.line2,                forKey: .line2)
        try container.encodeIfPresent   (self.city,                 forKey: .city)
        try container.encodeIfPresent   (self.state,                forKey: .state)
        try container.encodeIfPresent   (self.zipCode,              forKey: .zipCode)
        try container.encodeIfPresent   (self.countryGovernorate,   forKey: .countryGovernorate)
        try container.encodeIfPresent   (self.area,                 forKey: .area)
        try container.encodeIfPresent   (self.block,                forKey: .block)
        try container.encodeIfPresent   (self.avenue,               forKey: .avenue)
        try container.encodeIfPresent   (self.street,               forKey: .street)
        try container.encodeIfPresent   (self.buildingHouse,        forKey: .buildingHouse)
        try container.encodeIfPresent   (self.floor,                forKey: .floor)
        try container.encodeIfPresent   (self.office,               forKey: .office)
        try container.encodeIfPresent   (self.postalBox,            forKey: .postalBox)
        try container.encodeIfPresent   (self.postalCode,           forKey: .postalCode)
    }
}
