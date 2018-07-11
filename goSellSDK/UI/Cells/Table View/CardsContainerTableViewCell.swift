//
//  CardsContainerTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UICollectionView.UICollectionView

internal class CardsContainerTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardsContainerTableViewCellModel?
    
    // MARK: - Private -
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView? {
        
        didSet {
            
            self.model?.collectionViewCellModels.forEach { $0.collectionView = self.cardsCollectionView }
        }
    }
}

// MARK: - BindingWithModelCell
extension CardsContainerTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        self.cardsCollectionView?.dataSource = self.model?.cardsCollectionViewHandler
        self.cardsCollectionView?.delegate = self.model?.cardsCollectionViewHandler
        self.model?.collectionViewCellModels.forEach { $0.collectionView = self.cardsCollectionView }
    }
}

// MARK: - LoadingWithModelCell
extension CardsContainerTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        
    }
}
