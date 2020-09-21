//
//  AddressFieldTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics

internal class AddressFieldTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let addressField: BillingAddressField
    internal let fieldSpecification: AddressField
    
    internal private(set) weak var inputListener: CardAddressInputListener?
    internal private(set) weak var dataStorage: CardAddressDataStorage?
    
    internal var descriptionText: String {
        
        return self.fieldSpecification.placeholder
    }
    
    internal var descriptionWidth: CGFloat = 0.0
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, addressField: BillingAddressField, specification: AddressField, inputListener: CardAddressInputListener, dataStorage: CardAddressDataStorage) {
        
        self.addressField       = addressField
        self.fieldSpecification = specification
        self.inputListener      = inputListener
        self.dataStorage        = dataStorage
        
        super.init(indexPath: indexPath)
    }
}
