//
//  CardsCollectionViewLayout.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGAffineTransform.CGAffineTransform
import class    UIKit.UICollectionViewFlowLayout.UICollectionViewFlowLayout
import class    UIKit.UICollectionViewLayout.UICollectionViewLayoutAttributes

internal class CardsCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        return attributes
    }
    
    internal override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.alpha = 1.0
        attributes?.transform = .identity
        
        return attributes
    }
    
    internal override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        return attributes
    }
}
