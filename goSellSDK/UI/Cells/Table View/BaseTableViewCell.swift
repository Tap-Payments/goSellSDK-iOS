//
//  BaseTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITableViewCell.UITableViewCell

/// Base Table View Cell.
internal class BaseTableViewCell: UITableViewCell {
    
    internal override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let glowingCell = self as? GlowingCell {
            
            glowingCell.prepareForGlowing()
        }
    }
    
    internal override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if let glowingCell = self as? GlowingCell {
            
            glowingCell.prepareForGlowing()
        }
    }
}
