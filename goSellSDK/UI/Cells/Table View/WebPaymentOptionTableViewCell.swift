//
//  WebPaymentOptionTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UITableViewCell.UITableViewCell

internal class WebPaymentOptionTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: WebPaymentOptionTableViewCellModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var iconImageView: UIImageView?
    
    @IBOutlet private var onePixelConstraints: [NSLayoutConstraint]? {
        
        didSet {
            
            let value = UIScreen.main.numberOfPointsInOnePixel
            self.onePixelConstraints?.forEach { $0.constant = value }
        }
    }
}

// MARK: - LoadingWithModelCell
extension WebPaymentOptionTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.titleLabel?.text = self.model?.title
        self.iconImageView?.image = self.model?.iconImage
    }
}

// MARK: - GlowingCell
extension WebPaymentOptionTableViewCell: GlowingCell {
    
    internal var glowingView: UIView { return self }
}
