//
//  GroupTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal class GroupTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal let key: LocalizationKey
    
    internal weak var cell: GroupTableViewCell?
    
    // MARK: Methods
    
	internal init(indexPath: IndexPath, key: LocalizationKey) {
		
		self.key = key
		
        super.init(indexPath: indexPath)
    }
}

// MARK: - SingleCellModel
extension GroupTableViewCellModel: SingleCellModel {}
