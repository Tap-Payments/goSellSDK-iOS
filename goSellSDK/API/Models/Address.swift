//
//  Address.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Address model.
internal struct Address: Decodable {
    
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
    
    /// Address type.
    internal var type: AddressType?
    
    /// Country.
    internal var country: Country?
    
    /// Address line 1.
    internal var line1: String?
    
    /// Address line 2.
    internal var line2: String?
    
    /// Address city.
    internal var city: String?
    
    /// Address state.
    internal var state: String?
    
    /// Address zip code.
    internal var zipCode: String?
    
    /// Address country governorate.
    internal var countryGovernorate: String?
    
    /// Address area.
    internal var area: String?
    
    /// Address block.
    internal var block: String?
    
    /// Address avenue.
    internal var avenue: String?
    
    /// Address street.
    internal var street: String?
    
    /// Address building or house.
    internal var buildingHouse: String?
    
    /// Address floor.
    internal var floor: String?
    
    /// Address office.
    internal var office: String?
    
    /// Address postal box.
    internal var postalBox: String?
    
    /// Address postal code.
    internal var postalCode: String?
    
    // MARK: Methods
    
    internal init(format: AddressFormat) {
        
        self.format = format
    }
}

// MARK: - Encodable
extension Address: Encodable {
    
    internal func encode(to encoder: Encoder) throws {
        
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
