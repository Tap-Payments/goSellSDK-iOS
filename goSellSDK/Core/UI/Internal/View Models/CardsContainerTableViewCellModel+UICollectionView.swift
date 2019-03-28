//
//  CardsContainerTableViewCellModel+UICollectionView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UICollectionView.UICollectionView
import protocol UIKit.UICollectionView.UICollectionViewDataSource
import protocol UIKit.UICollectionView.UICollectionViewDelegate
import class    UIKit.UICollectionViewCell.UICollectionViewCell

internal extension CardsContainerTableViewCellModel {
    
    // MARK: - Internal -
    
    class CardsContainerTableViewCellModelCollectionViewHandler: NSObject {
        
        fileprivate unowned let model: CardsContainerTableViewCellModel
        
        internal required init(model: CardsContainerTableViewCellModel) {
            
            self.model = model
            super.init()
        }
    }
    
    // MARK: Methods
    
    func generateCollectionViewCellModels(with cards: [SavedCard]) -> [CardCollectionViewCellModel] {
        
        var result: [CardCollectionViewCellModel] = []
		
		let amountedCurrency = Process.shared.dataManagerInterface.selectedCurrency
        let currency = amountedCurrency.currency
        
        let cardsSortingClosure: (SavedCard, SavedCard) -> Bool = { (firstCard, secondCard) in
            
            let firstCardCurrencyIsSelected = firstCard.currency == currency
            let secondCardCurrencyIsSelected = secondCard.currency == currency
			
            if firstCardCurrencyIsSelected && secondCardCurrencyIsSelected {
                
                return firstCard.orderBy < secondCard.orderBy
            }
            else if firstCardCurrencyIsSelected {
                
                return true
            }
            else if secondCardCurrencyIsSelected {
                
                return false
            }
            else {
                
                return firstCard.orderBy < secondCard.orderBy
            }
        }
        
        let sortedCards = cards.sorted(by: cardsSortingClosure)
        
        sortedCards.forEach {
            
            let indexPath = self.nextCardCollectionViewCellIndexPath(for: result)
            let model = CardCollectionViewCellModel(indexPath: indexPath, card: $0, parentModel: self)
            
            result.append(model)
        }
        
        return result
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    @inline(__always) private func nextCardCollectionViewCellIndexPath(for temporaryResult: [CardCollectionViewCellModel]) -> IndexPath {
        
        return IndexPath(item: temporaryResult.count, section: 0)
    }
}

// MARK: - UICollectionViewDataSource
extension CardsContainerTableViewCellModel.CardsContainerTableViewCellModelCollectionViewHandler: UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.model.collectionViewCellModels.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellModel = self.cardCellModel(at: indexPath)
        let cell = cellModel.dequeueCell(from: collectionView, for: indexPath)
        
        return cell
    }
    
    private func cardCellModel(at indexPath: IndexPath) -> CardCollectionViewCellModel {
        
        return self.model.collectionViewCellModels[indexPath.item]
    }
}

// MARK: - UICollectionViewDelegate
extension CardsContainerTableViewCellModel.CardsContainerTableViewCellModelCollectionViewHandler: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cellModel = self.cardCellModel(at: indexPath)
        
        cellModel.updateCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellModel = self.cardCellModel(at: indexPath)
        cellModel.collectionViewDidSelectCell(collectionView)
        
        self.model.tableView?.tap_selectRow(at: self.model.indexPath, animated: true, scrollPosition: .none, callDelegate: true)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellModel = self.cardCellModel(at: indexPath)
        cellModel.collectionViewDidDeselectCell(collectionView)
    }
}
