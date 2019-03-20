//
//  GroupWithButtonTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

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
		
		Process.shared.viewModelsHandlerInterface.groupWithButtonModelButtonClicked()
	}
	
	internal func updateButtonTitle(_ isInEditMode: Bool) {
		
		self.buttonKey = isInEditMode ? .common_cancel : .common_edit
		self.updateCell(animated: true)
	}
}

// MARK: - SingleCellModel
extension GroupWithButtonTableViewCellModel: SingleCellModel {}
