//
//  UITableView+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITableView.UITableView
import enum UIKit.UITableView.UITableViewScrollPosition

internal extension UITableView {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func selectRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition, callDelegate: Bool) {
        
        guard (self.isEditing && self.allowsSelectionDuringEditing) || (!self.isEditing && self.allowsSelection) else { return }
        let allowsMultipleSelectionNow = (self.isEditing && self.allowsMultipleSelectionDuringEditing) || (!self.isEditing && self.allowsMultipleSelection)
        
        if let alreadySelectedIndexPath = self.indexPathForSelectedRow, !allowsMultipleSelectionNow {
            
            if alreadySelectedIndexPath == indexPath { return }
            else {
                
                self.deselectRow(at: alreadySelectedIndexPath, animated: animated)
                
                if callDelegate {
                    
                    self.delegate?.tableView?(self, didDeselectRowAt: alreadySelectedIndexPath)
                }
            }
        }
        
        self.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        
        if callDelegate {
            
            self.delegate?.tableView?(self, didSelectRowAt: indexPath)
        }
    }
}
