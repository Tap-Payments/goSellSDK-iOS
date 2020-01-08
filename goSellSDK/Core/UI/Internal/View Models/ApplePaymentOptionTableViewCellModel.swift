//
//  ApplePaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

import enum TapCardValidator.CardBrand
import class TapNetworkManager.TapImageLoader
import class UIKit.UIImage.UIImage

internal class ApplePaymentOptionTableViewCellModel: PaymentOptionTableCellViewModel {
    
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
    
    internal weak var cell: ApplePayTableViewCell? {
        
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
extension ApplePaymentOptionTableViewCellModel: SingleCellModel {}
