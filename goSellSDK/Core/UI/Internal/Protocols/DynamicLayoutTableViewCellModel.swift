//
//  DynamicCellHeightModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.UITableView.UITableView
import class	UIKit.UIView.UIView

/// Protocol to handle dynamic cell layout changes in the corresponding model.
internal protocol DynamicLayoutTableViewCellModel where Self: TableViewCellViewModel {}

internal extension DynamicLayoutTableViewCellModel {
    
    func updateCellLayout(animated: Bool, with code: @escaping TypeAlias.ArgumentlessClosure) {
		
		guard let nonnullTableView = self.tableView else { return }
		
        let closure: TypeAlias.ArgumentlessClosure = {

			let contentOffset = nonnullTableView.contentOffset
			
            nonnullTableView.beginUpdates()
            code()
            nonnullTableView.endUpdates()
			
			nonnullTableView.contentOffset = contentOffset
			nonnullTableView.tap_removeAllAnimations(includeSubviews: false)
        }

        if animated {

            closure()
        }
        else {

            UIView.performWithoutAnimation {

                closure()
            }
        }
    }
}
