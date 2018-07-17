//
//  CardCollectionViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    TapNetworkManager.TapImageLoader
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
        
        return PaymentDataManager.shared.paymentOptions.first { $0.supportedCardBrands.contains(self.card.brand) }
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, card: SavedCard) {
        
        self.card = card
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
    
    // MARK: Methods
    
    private func loadCardImages() {
        
        guard let cardBrandLogoURL = PaymentDataManager.shared.iconURL(for: self.card.brand) else { return }
        
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
        
        return PaymentDataManager.shared.currencySymbol(for: self.card.currency)
    }
    
    internal var cardNumberText: String {
        
        return Constants.cardNumberMaskingSymbols + " " + self.card.lastFourDigits
    }
    
    internal var checkmarkImage: UIImage {
        
        return Constants.checkmarkImage
    }
}

// MARK: - SingleCellModel
extension CardCollectionViewCellModel: SingleCellModel {}
