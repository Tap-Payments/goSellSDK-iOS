//
//  GroupWithButtonTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.UIButton.UIButton
import class	UIKit.UILabel.UILabel
import class	UIKit.UIView.UIView

internal class GroupWithButtonTableViewCell: BaseTableViewCell {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var model: GroupWithButtonTableViewCellModel?
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let labelTextChangeAnimationDuration: TimeInterval = 0.3
		
		//@available(*, unavailable) private init() { }
	}
	
	// MARK: Properties
	
	@IBOutlet private weak var titleLabel: UILabel?
	
	@IBOutlet private weak var buttonLabel: UILabel?
	@IBOutlet private weak var button: UIButton?
	
	// MARK: Methods
	
	@IBAction private func buttonClicked(_ sender: Any) {
		
		self.model?.buttonClicked()
	}
}

extension GroupWithButtonTableViewCell: LoadingWithModelCell {
	
	internal func updateContent(animated: Bool) {
		
		if let nonnullTitleLabel = self.titleLabel {
			
			nonnullTitleLabel.setLocalizedText(self.model?.key)
			nonnullTitleLabel.setTextStyle(Theme.current.paymentOptionsCellStyle.groupWithButton.titleStyle)
		}
		
		if let nonnullButtonLabel = self.buttonLabel {
			
			UIView.tap_fadeOutUpdateAndFadeIn(view:		nonnullButtonLabel,
											  with:		animated ? Constants.labelTextChangeAnimationDuration : 0.0,
											  update:	{ (label) in
												
												label.setLocalizedText(self.model?.buttonKey)
												label.setTextStyle(Theme.current.paymentOptionsCellStyle.groupWithButton.buttonTitleStyle)
			})
		}
        
        
        self.backgroundColor = UIColor.clear
	}
}
