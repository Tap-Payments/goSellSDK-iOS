//
//  TitleTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal final class TitleTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setTitle(_ title: CustomStringConvertible) {
        
        self.titleTextLabel?.text = title.description
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextLabel: UILabel?
}
