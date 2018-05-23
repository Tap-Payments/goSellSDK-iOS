//
//  AddressFieldInputType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Input type enum.
///
/// - textInput: Text input with the specified text input type.
/// - dropdown: Dropdown.
internal enum AddressFieldInputType {
    
    case textInput(TextInputType)
    case dropdown
}

// MARK: - Decodable
extension AddressFieldInputType: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        switch stringValue {
            
        case Constants.dropdownInputType:
            
            self = .dropdown
            
        case Constants.numberInputType:
            
            self = .textInput(.digits)
            
        case Constants.textInputType:
            
            self = .textInput(.text)
            
        default:
            
            self = .textInput(.text)
            print("Unknown address field input type: \(stringValue)")
        }
    }
    
    private struct Constants {
        
        fileprivate static let textInputType = "text"
        fileprivate static let numberInputType = "number"
        fileprivate static let dropdownInputType = "dropdown"
        
        @available(*, unavailable) private init() {}
    }
}
