//
//  Address.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Address model.
internal struct Address: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Address format.
    internal var format: AddressFormat
    
    /// Address type.
    internal var type: AddressType?
    
    internal var country: Country
    
    /// Address line 1.
    internal var line1: String?
    
    /// Address line 2.
    internal var line2: String?
    
    /// Address city.
    internal var city: String
    
    /// Address state.
    internal var state: String
    
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
    
    internal init(country: Country, city: String, state: String, line1: String?, line2: String?, zipCode: String?) {
        
        self.init(format: .a, country: country, city: city, state: state)
        
        self.line1      = line1
        self.line2      = line2
        self.zipCode    = zipCode
    }
    
    internal init(country: Country, city: String, state: String, type: AddressType, countryGovernorate: String?, area: String?, block: String?, avenue: String?, street: String?, buildingHouse: String?, floor: String?, office: String?) {
        
        self.init(format: .b, country: country, city: city, state: state)
        
        self.type               = type
        self.countryGovernorate = countryGovernorate
        self.area               = area
        self.block              = block
        self.avenue             = avenue
        self.street             = street
        self.buildingHouse      = buildingHouse
        self.floor              = floor
        self.office             = office
    }
    
    internal init(country: Country, city: String, state: String, postalBox: String?, postalCode: String?) {
        
        self.init(format: .c, country: country, city: city, state: state)
        
        self.postalBox  = postalBox
        self.postalCode = postalCode
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
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
    
    // MARK: Methods
    
    private init(format: AddressFormat, country: Country, city: String, state: String) {
        
        self.format     = format
        self.country    = country
        self.city       = city
        self.state      = state
    }
}

// MARK: - Encodable
extension Address: Encodable {
    
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.format,   forKey: .format)
        try container.encode(self.country,  forKey: .country)
        try container.encode(self.city,     forKey: .city)
        try container.encode(self.state,    forKey: .state)
        
        switch self.format {
            
        case .a:
            
            try container.encodeIfPresent(self.line1,   forKey: .line1)
            try container.encodeIfPresent(self.line2,   forKey: .line2)
            try container.encodeIfPresent(self.zipCode, forKey: .zipCode)
            
        case .b:
            
            try container.encode            (self.type,                 forKey: .type)
            try container.encodeIfPresent   (self.countryGovernorate,   forKey: .countryGovernorate)
            try container.encodeIfPresent   (self.area,                 forKey: .area)
            try container.encodeIfPresent   (self.block,                forKey: .block)
            try container.encodeIfPresent   (self.avenue,               forKey: .avenue)
            try container.encodeIfPresent   (self.street,               forKey: .street)
            try container.encodeIfPresent   (self.buildingHouse,        forKey: .buildingHouse)
            try container.encodeIfPresent   (self.floor,                forKey: .floor)
            try container.encodeIfPresent   (self.office,               forKey: .office)
            
        case .c:
            
            try container.encodeIfPresent(self.postalBox,   forKey: .postalBox)
            try container.encodeIfPresent(self.postalCode,  forKey: .postalCode)
        }
    }
}
