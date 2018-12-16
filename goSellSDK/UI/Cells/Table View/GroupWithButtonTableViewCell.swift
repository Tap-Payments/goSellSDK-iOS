//
//  GroupWithButtonTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class GroupWithButtonTableViewCell: BaseTableViewCell {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var model: GroupWithButtonTableViewCellModel?
	
	// MARK: - Private -
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
		
		self.titleLabel?.setLocalizedText(self.model?.key)
		self.titleLabel?.setTextStyle(Theme.current.paymentOptionsCellStyle.groupWithButton.titleStyle)
		
		self.buttonLabel?.setLocalizedText(self.model?.buttonKey)
		self.buttonLabel?.setTextStyle(Theme.current.paymentOptionsCellStyle.groupWithButton.buttonTitleStyle)
	}
}
