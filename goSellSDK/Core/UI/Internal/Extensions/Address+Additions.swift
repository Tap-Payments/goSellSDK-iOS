//
//  Address+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Address {
    
    // MARK: - Internal -
    // MARK: Methods
    
	convenience init?(inputData: [String: Any], format: BillingAddressFormat) {
        
        self.init(format: format.name)
        
        for field in format.fields {
            
            guard let codingKey = CodingKeys(rawValue: field.name) else { return nil }
            let value = inputData[field.name]
            
            switch codingKey {
                
            case .format:               self.format = format.name
                
            case .type:                 if let type                 = AddressType(untransformedValue:   value) { self.type                  = type                  } else if field.isRequired { return nil }
            case .country:              if let country              = Country(untransformedValue:       value) { self.country               = country               } else if field.isRequired { return nil }
            case .line1:                if let line1                = String(untransformedValue:        value) { self.line1                 = line1                 } else if field.isRequired { return nil }
            case .line2:                if let line2                = String(untransformedValue:        value) { self.line2                 = line2                 } else if field.isRequired { return nil }
            case .city:                 if let city                 = String(untransformedValue:        value) { self.city                  = city                  } else if field.isRequired { return nil }
            case .state:                if let state                = String(untransformedValue:        value) { self.state                 = state                 } else if field.isRequired { return nil }
            case .zipCode:              if let zipCode              = String(untransformedValue:        value) { self.zipCode               = zipCode               } else if field.isRequired { return nil }
            case .countryGovernorate:   if let countryGovernorate   = String(untransformedValue:        value) { self.countryGovernorate    = countryGovernorate    } else if field.isRequired { return nil }
            case .area:                 if let area                 = String(untransformedValue:        value) { self.area                  = area                  } else if field.isRequired { return nil }
            case .block:                if let block                = String(untransformedValue:        value) { self.block                 = block                 } else if field.isRequired { return nil }
            case .avenue:               if let avenue               = String(untransformedValue:        value) { self.avenue                = avenue                } else if field.isRequired { return nil }
            case .street:               if let street               = String(untransformedValue:        value) { self.street                = street                } else if field.isRequired { return nil }
            case .buildingHouse:        if let buildingHouse        = String(untransformedValue:        value) { self.buildingHouse         = buildingHouse         } else if field.isRequired { return nil }
            case .floor:                if let floor                = String(untransformedValue:        value) { self.floor                 = floor                 } else if field.isRequired { return nil }
            case .office:               if let office               = String(untransformedValue:        value) { self.office                = office                } else if field.isRequired { return nil }
            case .postalBox:            if let postalBox            = String(untransformedValue:        value) { self.postalBox             = postalBox             } else if field.isRequired { return nil }
            case .postalCode:           if let postalCode           = String(untransformedValue:        value) { self.postalCode            = postalCode            } else if field.isRequired { return nil }

            }
        }
    }
}
