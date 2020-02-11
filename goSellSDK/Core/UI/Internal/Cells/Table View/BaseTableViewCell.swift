//
//  BaseTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UITableViewCell.UITableViewCell

/// Base Table View Cell.
internal class BaseTableViewCell: UITableViewCell {
	
	// MARK: - Internal -
	// MARK: Methods
	
    internal override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let glowingCell = self as? GlowingViewHandler {
            
            glowingCell.prepareForGlowing()
        }
		
		self.tap_updateLayoutDirectionIfRequired()
        
        self.backgroundColor = UIColor.white.loadCompatibleDarkModeColor(forColorNamed: "DefaultCellColor")
       
    }
    
    internal override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if let glowingCell = self as? GlowingViewHandler {
            
            glowingCell.prepareForGlowing()
        }
		
		self.tap_updateLayoutDirectionIfRequired()
    }
}
