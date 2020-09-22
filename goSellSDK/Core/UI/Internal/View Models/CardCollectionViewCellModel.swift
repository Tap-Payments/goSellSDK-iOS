//
//  CardCollectionViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKitV2.TypeAlias
import class    TapNetworkManagerV2.TapImageLoader
import class    UIKit.UIImage.UIImage

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
		
		return Process.shared.dataManagerInterface.paymentOptions.first(where: { $0.identifier == self.card.paymentOptionIdentifier } )
    }
	
	internal var isDeleteCellMode: Bool = false {
	
		didSet {
			
			guard self.isDeleteCellMode != oldValue else { return }
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
        //@available(*, unavailable) private init() { }
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
    
    private unowned let parentModel: CardsContainerTableViewCellModel
    
    // MARK: Methods
    
    private func loadCardImages() {
        
        guard let cardBrandLogoURL = Process.shared.dataManagerInterface.iconURL(for: self.card.brand, scheme: self.card.scheme) else { return }
        
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
		
		let alert = TapAlertController(titleKey: 		.alert_delete_card_title,
									   messageKey: 		.alert_delete_card_message, self.cardNumberText,
									   preferredStyle:	.alert)
		
		let cancelAction = TapAlertController.Action(titleKey: .alert_delete_card_btn_cancel_title, style: .cancel) { [weak alert] (action) in
			
			alert?.hide()
            decision(false)
        }
		
        let deleteAction = TapAlertController.Action(titleKey: .alert_delete_card_btn_delete_title, style: .destructive) { [weak alert] (action) in
			
			alert?.hide()
            decision(true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.show()
    }
    
    private func deleteCard() {
        
        guard
			
			let customerIdentifier = Process.shared.externalSession?.dataSource?.customer?.identifier,
			let cardIdentifier = self.card.identifier,
			let paymentContentController = PaymentContentViewController.tap_findInHierarchy()
			
		else { return }
		
		LoadingView.show(in: paymentContentController, animated: true)
		
        APIClient.shared.deleteCard(with: cardIdentifier, from: customerIdentifier) { [weak self] (response, error) in
			
			paymentContentController.hideLoader()
			
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
			
			return Process.shared.dataManagerInterface.currencySymbol(for: currency)
        }
        else {
            
            return .tap_empty
        }
    }
    
    internal var cardNumberText: String {
        
        return Constants.cardNumberMaskingSymbols + " " + self.card.lastFourDigits
    }
    
    internal var checkmarkImage: UIImage {
        
        return Theme.current.paymentOptionsCellStyle.savedCard.checkmarkIcon
    }
    
    internal var deleteCardImage: UIImage {
		
		return Theme.current.commonStyle.icons.closeImage
    }
	
	internal func cellTapDetected() {
		
		Process.shared.dataManagerInterface.isInDeleteSavedCardsMode = false
	}
	
	internal func cellLongPressDetected() {
		
		Process.shared.dataManagerInterface.isInDeleteSavedCardsMode = true
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
