//
//  DynamicCellHeightModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.UITableView.UITableView
import class UIKit.UIView.UIView

/// Protocol to handle dynamic cell layout changes in the corresponding model.
internal protocol DynamicLayoutTableViewCellModel {
    
    var tableView: UITableView? { get }
}

internal extension DynamicLayoutTableViewCellModel where Self: TableViewCellViewModel {
    
    internal func updateCellLayout(animated: Bool, with code: @escaping TypeAlias.ArgumentlessClosure) {
        
        let closure: TypeAlias.ArgumentlessClosure = {

            self.tableView?.beginUpdates()
            code()
            self.tableView?.endUpdates()
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
