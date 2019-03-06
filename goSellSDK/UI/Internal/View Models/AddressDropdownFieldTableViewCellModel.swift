//
//  AddressDropdownFieldTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage

/// Cell model to manage address dropdown field.
internal class AddressDropdownFieldTableViewCellModel: AddressFieldTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: AddressDropdownFieldTableViewCell?
    
    internal var preselectedValueText: String {
        
        return self.preselectedValue?.displayValue ?? .tap_empty
    }
    
    internal var arrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
    }
    
    internal var preselectedValue: ListValue? {
        
        didSet {
            
            self.inputListener?.inputChanged(in: self.addressField, to: self.preselectedValue)
            self.updateCell()
        }
    }
    
    internal let allValues: [ListValue]
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, field: BillingAddressField, specification: AddressField, allValues: [ListValue], preselectedValue: ListValue?, inputListener: CardAddressInputListener, dataStorage: CardAddressDataStorage) {
        
        self.allValues          = allValues
        self.preselectedValue   = preselectedValue
        
        super.init(indexPath: indexPath, addressField: field, specification: specification, inputListener: inputListener, dataStorage: dataStorage)
    }
}

// MARK: - SingleCellModel
extension AddressDropdownFieldTableViewCellModel: SingleCellModel {}
