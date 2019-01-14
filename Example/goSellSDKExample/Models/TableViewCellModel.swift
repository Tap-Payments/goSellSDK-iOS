//
//  TableViewCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UITableViewCell.UITableViewCell

internal class TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var isSelected = false
    
    internal class var cellClass: UITableViewCell.Type {
        
        return UITableViewCell.self
    }
}
