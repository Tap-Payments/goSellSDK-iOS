//
//  CardCollectionViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    TapNetworkManager.TapImageLoader
import class    UIKit.UIAlertController.UIAlertAction
import class    UIKit.UIAlertController.UIAlertController
import class    UIKit.UIImage.UIImage
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class CardCollectionViewCellModel: PaymentOptionCollectionCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardCollectionViewCell?
    
    internal let card: SavedCard
    
    internal override var isSelected: Bool {
        
        didSet {
            
            self.updateCell()
        }
    }
    
    internal override var paymentOption: PaymentOption? {
        
        return PaymentDataManager.shared.paymentOptions.first(where: { $0.identifier == self.card.paymentOptionIdentifier } )
    }
    
    internal var isDeleteCellMode: Bool {
        
        get {
            
            return self.storedIsInDeleteCellMode
        }
        set {
            
            guard self.storedIsInDeleteCellMode != newValue else { return }
            self.storedIsInDeleteCellMode = newValue
            
            PaymentDataManager.shared.isInDeleteSavedCardsMode = newValue
            
            self.updateCell(animated: true)
        }
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, card: SavedCard, parentModel: CardsContainerTableViewCellModel) {
        
        self.card           = card
        self.parentModel    = parentModel
        
        super.init(indexPath: indexPath)
        
        self.loadCardImages()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let cardNumberMaskingSymbols = "●●●●"
        fileprivate static let checkmarkImage: UIImage = {
            
            guard let result = UIImage.named("ic_checkmark_green_small", in: .goSellSDKResources) else {
                
                fatalError("Failed to load image.")
            }
            
            return result
        }()
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var cardBrandImage: UIImage = UIImage() {
        
        didSet {
            
            self.updateCell()
        }
    }
    
    private var cardBankLogo: UIImage? {
        
        didSet {
            
            self.updateCell()
        }
    }
    
    private var storedIsInDeleteCellMode = false
    
    private unowned let parentModel: CardsContainerTableViewCellModel
    
    // MARK: Methods
    
    private func loadCardImages() {
        
        guard let cardBrandLogoURL = PaymentDataManager.shared.iconURL(for: self.card.brand, scheme: self.card.scheme) else { return }
        
        TapImageLoader.shared.downloadImage(from: cardBrandLogoURL) { [weak self] (image, error) in
            
            guard let strongSelf = self, let nonnullImage = image else { return }
            
            strongSelf.cardBrandImage = nonnullImage
        }
        
        BINDataManager.shared.retrieveBINData(for: self.card.firstSixDigits) { [weak self] (response) in
            
            guard let strongSelf = self, let bankURL = response.bankLogoURL else { return }
            
            TapImageLoader.shared.downloadImage(from: bankURL) { [weak strongSelf] (image, error) in
                
                guard let strongerSelf = strongSelf, let nonnullImage = image else { return }
                strongerSelf.cardBankLogo = nonnullImage
            }
        }
    }
    
    private func showDeleteCardAlert(with decision: @escaping TypeAlias.BooleanClosure) {
        
        let alert = UIAlertController(title: "Delete Card", message: "Are you sure you would like to delete card \(self.cardNumberText)?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak alert] (action) in
            
            alert?.dismissFromSeparateWindow(true, completion: nil)
            decision(false)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak alert] (action) in
            
            alert?.dismissFromSeparateWindow(true, completion: nil)
            decision(true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        DispatchQueue.main.async {
            
            alert.showOnSeparateWindow(true, below: .statusBar, completion: nil)
        }
    }
    
    private func deleteCard() {
        
        guard let customerIdentifier = PaymentDataManager.shared.externalDataSource?.customer?.identifier, let cardIdentifier = self.card.identifier else { return }
        
        let loader = PaymentDataManager.shared.showLoadingController(false)
        APIClient.shared.deleteCard(with: cardIdentifier, from: customerIdentifier) { [weak loader, weak self] (response, error) in
            
            loader?.hide(animated: true, async: true, fromDestroyInstance: false)
            
            if let nonnullError = error {
                
                ErrorDataManager.handle(nonnullError, retryAction: { self?.deleteCard() }, alertDismissButtonClickHandler: nil)
            }
            else if let strongSelf = self {
                
                strongSelf.parentModel.deleteCardModel(strongSelf)
            }
        }
    }
}

// MARK: - CardCollectionViewCellModel
extension CardCollectionViewCellModel: CardCollectionViewCellLoading {
    
    internal var smallImage: UIImage? {
        
        return self.cardBankLogo == nil ? nil : self.cardBrandImage
    }
    
    internal var bigImage: UIImage {
        
        return self.cardBankLogo ?? self.cardBrandImage
    }
    
    internal var currencyLabelText: String {
        
        if let currency = self.card.currency {
            
            return PaymentDataManager.shared.currencySymbol(for: currency)
        }
        else {
            
            return .empty
        }
    }
    
    internal var cardNumberText: String {
        
        return Constants.cardNumberMaskingSymbols + " " + self.card.lastFourDigits
    }
    
    internal var checkmarkImage: UIImage {
        
        return Constants.checkmarkImage
    }
    
    internal var deleteCardImage: UIImage {
        
        return Theme.current.settings.generalImages.closeImage
    }
    
    internal func deleteCardButtonClicked() {
        
        self.showDeleteCardAlert { [weak self] (shouldDeleteCard) in
            
            guard shouldDeleteCard else { return }
            
            self?.deleteCard()
        }
    }
}

// MARK: - SingleCellModel
extension CardCollectionViewCellModel: SingleCellModel {}

// MARK: - Equatable
extension CardCollectionViewCellModel: Equatable {
    
    internal static func == (lhs: CardCollectionViewCellModel, rhs: CardCollectionViewCellModel) -> Bool {
        
        return lhs.card == rhs.card
    }
}
