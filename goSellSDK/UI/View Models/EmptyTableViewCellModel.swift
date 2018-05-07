//
//  EmptyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class EmptyTableViewCellModel: CellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: EmptyTableViewCell?
    
    internal let identifier: String
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, identifier: String) {
        
        self.identifier = identifier
        super.init(indexPath: indexPath)
    }
}

// MARK: - SingleCellModel
extension EmptyTableViewCellModel: SingleCellModel {}
