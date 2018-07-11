//
//  CollectionViewCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UICollectionView.UICollectionView

internal class CollectionViewCellViewModel: CellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var collectionView: UICollectionView?
    
    // MARK: Methods
    
    internal func collectionViewDidSelectCell(_ sender: UICollectionView) { }
    
    internal func collectionViewDidDeselectCell(_ sender: UICollectionView) { }
}
