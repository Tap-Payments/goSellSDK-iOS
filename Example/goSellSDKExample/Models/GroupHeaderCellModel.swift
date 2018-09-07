//
//  GroupHeaderCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UITableViewCell.UITableViewCell

internal class GroupHeaderCellModel: TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let title: String
    
    internal override class var cellClass: UITableViewCell.Type {
        
        return GroupHeaderCell.self
    }
    
    // MARK: Methods
    
    internal init(title: String) {
        
        self.title = title
    }
}
