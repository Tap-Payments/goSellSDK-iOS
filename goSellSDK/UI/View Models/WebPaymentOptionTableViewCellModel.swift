//
//  WebPaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand
import class TapNetworkManager.TapImageLoader
import class UIKit.UIImage.UIImage

internal class WebPaymentOptionTableViewCellModel: PaymentOptionTableCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let title: String
    
    internal let iconImageURL: URL
    
    internal let paymentOption: PaymentOption
    
    internal private(set) var iconImage: UIImage?
    
    internal weak var cell: WebPaymentOptionTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    internal var arrowImage: UIImage {
        
        return Theme.current.settings.generalImages.arrowRight
    }
    
    internal override var isReadyForPayment: Bool {
        
        return true
    }
    
    internal override var affectsPayButtonState: Bool {
        
        return false
    }
    
    internal override var initiatesPaymentOnSelection: Bool {
        
        return true
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, title: String, iconImageURL: URL, paymentOption: PaymentOption) {
        
        self.title = title
        self.iconImageURL = iconImageURL
        self.paymentOption = paymentOption
        
        super.init(indexPath: indexPath)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private func loadImageAndUpdateCell() {
        
        TapImageLoader.shared.downloadImage(from: self.iconImageURL) { [weak self] (image, _) in
            
            guard let strongSelf = self else { return }
            
            if let nonnullImage = image {
                
                strongSelf.iconImage = nonnullImage
                strongSelf.updateCell()
            }
        }
    }
}

// MARK: - SingleCellModel
extension WebPaymentOptionTableViewCellModel: SingleCellModel {}
