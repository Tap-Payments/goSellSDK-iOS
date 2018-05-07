//
//  WebPaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNetworkManager.TapImageLoader
import class UIKit.UIImage.UIImage

internal class WebPaymentOptionTableViewCellModel: CellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let title: String
    
    internal let iconImageURL: URL
    
    internal var iconImage: UIImage?
    
    internal weak var cell: WebPaymentOptionTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    internal override var indexPathOfCellToSelect: IndexPath? {
        
        return self.indexPath
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, title: String, iconImageURL: URL) {
        
        self.title = title
        self.iconImageURL = iconImageURL
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
