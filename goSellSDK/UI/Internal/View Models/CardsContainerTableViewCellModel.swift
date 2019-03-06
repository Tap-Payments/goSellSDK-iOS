//
//  CardsContainerTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal class CardsContainerTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardsContainerTableViewCell?
    
    internal private(set) var collectionViewCellModels: [CardCollectionViewCellModel] = [] {
        
        didSet {
            
            self.updateCell(animated: true)
        }
    }
    
    internal private(set) lazy var cardsCollectionViewHandler: CardsContainerTableViewCellModelCollectionViewHandler = CardsContainerTableViewCellModelCollectionViewHandler(model: self)
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, cards: [SavedCard]) {
		
        super.init(indexPath: indexPath)
        
		self.updateData(with: cards)
    }
    
	internal func updateData(with cards: [SavedCard]) {
		
		self.cards = cards
		
        self.collectionViewCellModels = self.generateCollectionViewCellModels(with: self.cards)
    }
    
    internal func deleteCardModel(_ model: CardCollectionViewCellModel) {
		
		Process.shared.dataManagerInterface.updateUIByRemoving(model.card)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var cards: [SavedCard] = []
}

// MARK: - SingleCellModel
extension CardsContainerTableViewCellModel: SingleCellModel {}
