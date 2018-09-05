//
//  GroupHeaderCell.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal final class GroupHeaderCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setGroupTitle(_ groupTitle: String) {
        
        self.groupTitleLabel?.text = groupTitle
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var groupTitleLabel: UILabel?
}
