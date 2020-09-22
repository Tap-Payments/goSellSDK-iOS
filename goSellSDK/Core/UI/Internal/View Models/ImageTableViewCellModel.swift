//
//  ImageTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class TapNetworkManagerV2.TapImageLoader
import class UIKit.UIImage.UIImage

internal class ImageTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let imageURL: URL
    
    internal var image: UIImage?
    
    internal weak var cell: ImageTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, imageURL: URL) {
        
        self.imageURL = imageURL
        super.init(indexPath: indexPath)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func loadImageAndUpdateCell() {
        
        TapImageLoader.shared.downloadImage(from: self.imageURL) { [weak self] (image, _) in
            
            guard let strongSelf = self else { return }
            
            if let nonnullImage = image {
                
                strongSelf.image = nonnullImage
                strongSelf.updateCell()
            }
        }
    }
}

extension ImageTableViewCellModel: Equatable {
    
    internal static func == (lhs: ImageTableViewCellModel, rhs: ImageTableViewCellModel) -> Bool {
        
        guard lhs.imageURL == rhs.imageURL, lhs.indexPath == rhs.indexPath else { return false }
        
        let imagesAreEqual = (lhs.image == nil && rhs.image == nil) || (lhs.image != nil && rhs.image != nil && lhs.image == rhs.image)
        return imagesAreEqual
    }
}

// MARK: - SingleCellModel
extension ImageTableViewCellModel: SingleCellModel {}
