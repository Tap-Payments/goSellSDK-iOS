//
//  GroupWithButtonTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class GroupWithButtonTableViewCellModel: TableViewCellViewModel {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let key: LocalizationKey
	
	internal weak var cell: GroupWithButtonTableViewCell?
	
	internal var buttonKey: LocalizationKey = .common_edit
	
	// MARK: Methods
	
	internal init(indexPath: IndexPath, key: LocalizationKey) {
		
		self.key = key
		
		super.init(indexPath: indexPath)
	}
	
	internal func buttonClicked() {
		
		PaymentDataManager.shared.isInDeleteSavedCardsMode = !PaymentDataManager.shared.isInDeleteSavedCardsMode
	}
	
	internal func updateButtonTitle(_ isInEditMode: Bool) {
		
		self.buttonKey = isInEditMode ? .common_cancel : .common_edit
		self.updateCell()
	}
}

// MARK: - SingleCellModel
extension GroupWithButtonTableViewCellModel: SingleCellModel {}
