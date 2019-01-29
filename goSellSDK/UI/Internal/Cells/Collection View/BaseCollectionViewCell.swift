//
//  BaseCollectionViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UICollectionViewCell.UICollectionViewCell

/// Base Collection View Cell.
internal class BaseCollectionViewCell: UICollectionViewCell {
    
    internal override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let glowingCell = self as? GlowingViewHandler {
            
            glowingCell.prepareForGlowing()
        }
		
		self.tap_updateLayoutDirectionIfRequired()
    }
    
    internal override func prepareForReuse() {

        super.prepareForReuse()
        
        if let glowingCell = self as? GlowingViewHandler {
            
            glowingCell.prepareForGlowing()
        }
		
		self.tap_updateLayoutDirectionIfRequired()
    }
}
