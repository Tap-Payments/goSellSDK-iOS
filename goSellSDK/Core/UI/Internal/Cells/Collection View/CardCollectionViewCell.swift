//
//  CardCollectionViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UIButton.UIButton
import class    UIKit.UIColor.UIColor
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UILongPressGestureRecognizer.UILongPressGestureRecognizer
import class    UIKit.UITapGestureRecognizer.UITapGestureRecognizer
import class    UIKit.UIView.UIView

internal class CardCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardCollectionViewCellLoading?
    
    // MARK: Methods
    
    internal override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.addTapRecognizer()
        self.addLongPressRecognizer()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.3
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var cardBackgroundView:  UIView?
    @IBOutlet private weak var smallIconImageView:  UIImageView?
    @IBOutlet private weak var bigIconImageView:    UIImageView?
    @IBOutlet private weak var cardNumberLabel:     UILabel?
    @IBOutlet private weak var currencyLabel:       UILabel?
    @IBOutlet private weak var checkmarkImageView:  UIImageView?
    @IBOutlet private weak var deleteView:          UIView?
    @IBOutlet private weak var deleteIconImageView: UIImageView?
    @IBOutlet private weak var deleteButton:        UIButton?
    
    private weak var tapRecognizer: UITapGestureRecognizer?
    private weak var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    // MARK: Methods
    
    @IBAction private func deleteCardButtonHighlighted(_ sender: Any) {
        
        self.deleteIconImageView?.isHighlighted = true
    }
    
    @IBAction private func deleteCardButtonLostHighlight(_ sender: Any) {
        
        self.deleteIconImageView?.isHighlighted = false
    }
    
    @IBAction private func deleteCardButtonTouchUpInside(_ sender: Any) {
        
        self.model?.deleteCardButtonClicked()
    }
    
    private func addTapRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.addGestureRecognizer(recognizer)
        
        self.tapRecognizer = recognizer
    }
    
    private func addLongPressRecognizer() {
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected(_:)))
        recognizer.minimumPressDuration = 1.0
        self.addGestureRecognizer(recognizer)
        
        self.longPressGestureRecognizer = recognizer
    }
    
    @objc private func longPressDetected(_ sender: Any) {
		
		self.model?.cellLongPressDetected()
    }
    
    @objc private func tapDetected(_ sender: Any) {
		
		self.model?.cellTapDetected()
    }
}

// MARK: - LoadingWithModelCell
extension CardCollectionViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        let selected = self.model?.isSelected ?? false
        if self.isSelected != selected {
            
            self.isSelected = selected
        }
        
        self.setGlowing(selected)
        
        self.currencyLabel?.text        = self.model?.currencyLabelText
        self.cardNumberLabel?.text      = self.model?.cardNumberText
		self.cardNumberLabel?.setTextStyle(Theme.current.paymentOptionsCellStyle.savedCard.cardNumber)
        self.cardBackgroundView?.backgroundColor = UIColor(tap_hex: "ffffff")?.loadCompatibleDarkModeColor(forColorNamed: "SavedCardCellBackgroundColor")
        self.checkmarkImageView?.image  = self.model?.checkmarkImage
        self.deleteIconImageView?.image = self.model?.deleteCardImage
        self.deleteIconImageView?.highlightedImage = self.model?.deleteCardImage
        
        if let smallImageView = self.smallIconImageView, let smallImage = self.model?.smallImage {
            
            smallImageView.image = smallImage
            smallImageView.contentMode = smallImage.tap_bestContentMode(toFit: smallImageView.bounds.size)
        }
        
        if let bigImageView = self.bigIconImageView, let bigImage = self.model?.bigImage {
            
            bigImageView.image = bigImage
            bigImageView.contentMode = bigImage.tap_bestContentMode(toFit: bigImageView.bounds.size)
        }
        
        if self.model?.isDeleteCellMode ?? false {
            
            self.tapRecognizer?.isEnabled = true
            self.longPressGestureRecognizer?.isEnabled = false
            
            self.startWobbling()
        }
        else {
            
            self.tapRecognizer?.isEnabled = false
            self.longPressGestureRecognizer?.isEnabled = true
            
            self.stopWobbling()
        }
        
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0.0) {
            
            self.checkmarkImageView?.alpha = selected ? 1.0 : 0.0
            
            let isDeleteCellMode = self.model?.isDeleteCellMode ?? false
            self.deleteView?.alpha = isDeleteCellMode ? 1.0 : 0.0
            self.deleteView?.isUserInteractionEnabled = isDeleteCellMode
        }
    }
}

// MARK: - AlwaysGlowingViewHandler
extension CardCollectionViewCell: AlwaysGlowingViewHandler {
    
    internal var glowingView: UIView {
        
        return self.cardBackgroundView ?? self
    }
    
    internal var standartGlowColor: UIColor {
		
		return Theme.current.paymentOptionsCellStyle.alwaysGlowStyle.color.color
    }
}

// MARK: - WobblingViewHandler
extension CardCollectionViewCell: WobblingViewHandler {
    
    internal var wobblingView: UIView {
        
        return self
    }
}
