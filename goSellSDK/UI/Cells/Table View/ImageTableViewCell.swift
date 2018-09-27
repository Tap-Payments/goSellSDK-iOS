//
//  ImageTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView

/// Image Table View Cell Class
internal class ImageTableViewCell: BaseTableViewCell {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var model: ImageTableViewCellModel?
	
	// MARK: - Private -
	// MARK: Properties
	
	@IBOutlet private weak var imageImageView: UIImageView?
}

// MARK: - LoadingWithModelCell
extension ImageTableViewCell: LoadingWithModelCell {
	
	internal func updateContent(animated: Bool) {
		
		self.imageImageView?.image = self.model?.image
	}
}
