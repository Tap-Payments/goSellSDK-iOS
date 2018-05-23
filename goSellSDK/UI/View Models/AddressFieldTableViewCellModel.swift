//
//  AddressFieldTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat

internal class AddressFieldTableViewCellModel: CellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let addressField: AddressField
    
    internal private(set) weak var inputListener: CardAddressInputListener?
    internal private(set) weak var dataStorage: CardAddressDataStorage?
    
    internal var descriptionText: String {
        
        return self.addressField.placeholder
    }
    
    internal var descriptionWidth: CGFloat = 0.0
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, addressField: AddressField, inputListener: CardAddressInputListener, dataStorage: CardAddressDataStorage) {
        
        self.addressField = addressField
        self.inputListener = inputListener
        self.dataStorage = dataStorage
        super.init(indexPath: indexPath)
    }
}
