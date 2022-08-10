//
//  Address.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Address model.
@objc public final class Address: NSObject,Decodable {
    
    
    
    @available(swift, obsoleted: 1.0)
    @objc public convenience init?(type: AddressType, country: Country, line1: String? = nil, line2: String? = nil, line3: String? = nil, line4: String? = nil, city: String? = nil, state: String? = nil, zipCode: String? = nil, countryGovernorate: String? = nil, area: String? = nil, block: String? = nil, avenue: String? = nil, street: String? = nil, buildingHouse: String? = nil, floor: String? = nil, apartment: String? = nil, office: String? = nil, postalBox: String? = nil, postalCode: String? = nil) {
        
        self.init(type: type, country: country, line1: line1, line2: line2, line3: line3, line4: line4, city: city, state: state, zipCode: zipCode, countryGovernorate: countryGovernorate, area: area, block: block, avenue: avenue, street: street, buildingHouse: buildingHouse, floor: floor, apartment: apartment, office: office, postalBox: postalBox, postalCode: postalCode)
    }
    
    public init(type: AddressType? = nil, country: Country? = nil, line1: String? = nil, line2: String? = nil, line3: String? = nil, line4: String? = nil, city: String? = nil, state: String? = nil, zipCode: String? = nil, countryGovernorate: String? = nil, area: String? = nil, block: String? = nil, avenue: String? = nil, street: String? = nil, buildingHouse: String? = nil, floor: String? = nil, apartment: String? = nil, office: String? = nil, postalBox: String? = nil, postalCode: String? = nil) {
        self.type = type
        self.country = country
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.line4 = line4
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.countryGovernorate = countryGovernorate
        self.area = area
        self.block = block
        self.avenue = avenue
        self.street = street
        self.buildingHouse = buildingHouse
        self.floor = floor
        self.apartment = apartment
        self.office = office
        self.postalBox = postalBox
        self.postalCode = postalCode
        self.format = nil
    }
    
    
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
    
    /// Address line 3.
    public internal(set) var line3: String?
    
    /// Address line 4.
    public internal(set) var line4: String?
    
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
    
    /// Address apartment.
    public internal(set) var apartment: String?
    
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
        case line3              = "line3"
        case line4              = "line4"
		case city               = "city"
		case state              = "state"
		case zipCode            = "zip_code"
		case countryGovernorate = "country_governorate"
		case area               = "area"
		case block              = "block"
		case avenue             = "avenue"
		case street             = "street"
		case buildingHouse      = "building"
		case floor              = "floor"
		case office             = "office"
        case apartment          = "apartment"
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
        try container.encodeIfPresent   (self.line3,                forKey: .line3)
        try container.encodeIfPresent   (self.line4,                forKey: .line4)
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
        try container.encodeIfPresent   (self.apartment,            forKey: .apartment)
        try container.encodeIfPresent   (self.office,               forKey: .office)
        try container.encodeIfPresent   (self.postalBox,            forKey: .postalBox)
        try container.encodeIfPresent   (self.postalCode,           forKey: .postalCode)
    }
}




// MARK: - NSCopying
extension Address: NSCopying {
    
    /// Creates copy of the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Address(type: type, country: self.country, line1: self.line1, line2: self.line2, line3: self.line3, line4: self.line4, city: self.city, state: self.state, zipCode: self.zipCode, countryGovernorate: self.countryGovernorate, area: self.area, block: self.block, avenue: self.avenue, street: self.street, buildingHouse: self.buildingHouse, floor: floor, apartment: apartment, office: office, postalBox: postalBox, postalCode: postalCode)
    }
}
