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
        
        self.smallIconImageView?.image  = self.model?.smallImage
        self.bigIconImageView?.image    = self.model?.bigImage
        self.currencyLabel?.text        = self.model?.currencyLabelText
        self.cardNumberLabel?.text      = self.model?.cardNumberText
    }
}

// MARK: - GlowingCell
extension CardCollectionViewCell: GlowingCell {

    internal var glowingView: UIView {
        
        return self.cardBackgroundView ?? self
    }
}
