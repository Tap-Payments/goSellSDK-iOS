//
//  AddressFieldInputType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Input type enum.
///
/// - textInput: Text input with the specified text input type.
/// - dropdown: Dropdown.
internal enum AddressFieldInputType {
    
    case textInput(TextInputType)
    case dropdown
    
    // MARK: - Private -
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case Constants.dropdownInputType:
            
            self = .dropdown
            
        case Constants.numberInputType:
            
            self = .textInput(.digits)
            
        case Constants.textInputType:
            
            self = .textInput(.text)
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: AddressFieldInputType.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension AddressFieldInputType: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
    
    private struct Constants {
        
        fileprivate static let textInputType        = "TEXT"
        fileprivate static let numberInputType      = "NUMBER"
        fileprivate static let dropdownInputType    = "DROPDOWN"
        
        //@available(*, unavailable) private init() { }
    }
}
