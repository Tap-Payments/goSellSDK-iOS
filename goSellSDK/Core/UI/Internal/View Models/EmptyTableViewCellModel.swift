//
//  EmptyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal class EmptyTableViewCellModel: TableViewCellViewModel {
    
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
