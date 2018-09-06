//
//  SelectableCell.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UITableViewCell.UITableViewCell

internal class SelectableCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        self.checkmarkImageView?.isHidden = !selected
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var checkmarkImageView: UIImageView?
}
