//
//  CardCollectionViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIView.UIView

internal class CardCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardCollectionViewCellLoading?
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.3
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var cardBackgroundView:  UIView?
    @IBOutlet private weak var smallIconImageView:  UIImageView?
    @IBOutlet private weak var bigIconImageView:    UIImageView?
    @IBOutlet private weak var cardNumberLabel:     UILabel?
    @IBOutlet private weak var currencyLabel:       UILabel?
    @IBOutlet private weak var checkmarkImageView:  UIImageView?
}

// MARK: - LoadingWithModelCell
extension CardCollectionViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.currencyLabel?.text        = self.model?.currencyLabelText
        self.cardNumberLabel?.text      = self.model?.cardNumberText
        self.checkmarkImageView?.image  = self.model?.checkmarkImage
        
        if let smallImageView = self.smallIconImageView, let smallImage = self.model?.smallImage {
            
            smallImageView.image = smallImage
            smallImageView.contentMode = smallImage.bestContentMode(toFit: smallImageView.bounds.size)
        }
        
        if let bigImageView = self.bigIconImageView, let bigImage = self.model?.bigImage {
            
            bigImageView.image = bigImage
            bigImageView.contentMode = bigImage.bestContentMode(toFit: bigImageView.bounds.size)
        }
        
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0.0) {
            
            let selected = self.model?.isSelected ?? false
            self.checkmarkImageView?.alpha = selected ? 1.0 : 0.0
        }
    }
}

// MARK: - GlowingCell
extension CardCollectionViewCell: GlowingCell {

    internal var glowingView: UIView {
        
        return self.cardBackgroundView ?? self
    }
}
