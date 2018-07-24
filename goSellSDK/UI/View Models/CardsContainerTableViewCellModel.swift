//
//  CardsContainerTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class CardsContainerTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardsContainerTableViewCell?
    
    internal var collectionViewCellModels: [CardCollectionViewCellModel] = [] {
        
        didSet {
            
            self.updateCell(animated: true)
        }
    }
    
    internal lazy var cardsCollectionViewHandler: CardsContainerTableViewCellModelCollectionViewHandler = CardsContainerTableViewCellModelCollectionViewHandler(model: self)
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, cards: [SavedCard]) {
        
        self.cards = cards
        super.init(indexPath: indexPath)
        
        self.collectionViewCellModels = self.generateCollectionViewCellModels(with: cards)
    }
    
    internal func deleteCardModel(_ model: CardCollectionViewCellModel) {
        
        PaymentDataManager.shared.updateUIByRemoving(model.card)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let cards: [SavedCard]
}

// MARK: - SingleCellModel
extension CardsContainerTableViewCellModel: SingleCellModel {}
