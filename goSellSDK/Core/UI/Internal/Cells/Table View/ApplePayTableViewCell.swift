//
//  ApplePayTableViewCell.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

internal class ApplePayTableViewCell: BaseTableViewCell {
	
	internal weak var model: EmptyTableViewCellModel?
}

// MARK: - LoadingWithModelCell
extension ApplePayTableViewCell: LoadingWithModelCell {
	
	internal func updateContent(animated: Bool) { }
}

