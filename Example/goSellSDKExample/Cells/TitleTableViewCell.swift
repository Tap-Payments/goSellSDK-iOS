//
//  TitleTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal class TitleTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
	// MARK: Properties
	
	@IBOutlet internal private(set) weak var titleTextLabel: UILabel?
	
    // MARK: Methods
    
    internal func setTitle(_ title: CustomStringConvertible) {
        
		self.titleTextLabel?.text = title.description.capitalized
    }
}
