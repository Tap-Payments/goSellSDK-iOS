//
//  GroupTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class GroupTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let title: String
    
    internal weak var cell: GroupTableViewCell?
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, title: String) {
        
        self.title = title
        super.init(indexPath: indexPath)
    }
}

// MARK: - SingleCellModel
extension GroupTableViewCellModel: SingleCellModel {}
