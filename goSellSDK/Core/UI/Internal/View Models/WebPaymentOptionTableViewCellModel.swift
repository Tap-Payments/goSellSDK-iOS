//
//  WebPaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand
import class TapNetworkManagerV2.TapImageLoader
import class UIKit.UIImage.UIImage

internal class WebPaymentOptionTableViewCellModel: PaymentOptionTableCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var title: String { 
        
        return self.paymentOption.title
    }
    
    internal var iconImageURL: URL {
        
        return self.paymentOption.imageURL
    }
    
    internal override var paymentOption: PaymentOption {
        
        return self.storedPaymentOption
    }
    
    internal private(set) var iconImage: UIImage?
    
    internal weak var cell: WebPaymentOptionTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    internal var arrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
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
    
    internal init(indexPath: IndexPath, paymentOption: PaymentOption) {
        
        self.storedPaymentOption = paymentOption
        
        super.init(indexPath: indexPath)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let storedPaymentOption: PaymentOption
    
    // MARK: Methods
    
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
