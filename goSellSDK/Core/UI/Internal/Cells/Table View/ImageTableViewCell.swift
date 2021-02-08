//
//  ImageTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
    @IBOutlet private weak var paddingView: UIView!
    @IBOutlet weak var paddingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
}

// MARK: - LoadingWithModelCell
extension ImageTableViewCell: LoadingWithModelCell {
	
	internal func updateContent(animated: Bool) {
		
        DispatchQueue.main.async {

            self.imageImageView?.image = self.model?.image
            self.paddingView.layer.cornerRadius = 0
            self.paddingView.layer.masksToBounds = true
            
            self.paddingView.translatesAutoresizingMaskIntoConstraints = false
            self.imageImageView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.paddingWidthConstraint.constant = 32
            self.imageViewWidthConstraint.constant = 32
            
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark
                {
                    self.paddingView.layer.cornerRadius = 8
                    self.paddingWidthConstraint.constant = 32
                    self.imageViewWidthConstraint.constant = 22
                }
            }
        
            self.layoutIfNeeded()
            self.paddingView.layoutIfNeeded()
            self.imageImageView?.layoutIfNeeded()
        }
    }
}
