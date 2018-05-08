//
//  UICollectionView+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.UICollectionView.UICollectionView

internal extension UICollectionView {
    
    internal func reloadData(with batchUpdates: BatchUpdates) {
        
        let updates: TypeAlias.ArgumentlessClosure = {
            
            self.insertItems(at: batchUpdates.inserted.map { IndexPath(row: $0, section: 0) })
            self.deleteItems(at: batchUpdates.deleted.map { IndexPath(row: $0, section: 0) })
            
            batchUpdates.moved.forEach {
                
                let fromIndexPath = IndexPath(item: $0.0, section: 0)
                let toIndexPath = IndexPath(item: $0.1, section: 0)
                self.moveItem(at: fromIndexPath, to: toIndexPath)
            }
        }
        
        self.performBatchUpdates(updates, completion: nil)
    }
}
