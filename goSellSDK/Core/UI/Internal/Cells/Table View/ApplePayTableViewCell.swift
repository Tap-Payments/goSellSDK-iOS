//
//  ApplePayTableViewCell.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

import struct CoreGraphics.CGBase.CGFloat
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView

internal class ApplePayTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: ApplePaymentOptionTableViewCellModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    //@IBOutlet private weak var titleLabel:      UILabel?
    @IBOutlet private weak var iconImageView:   UIImageView?
    //@IBOutlet private weak var arrowImageView:  UIImageView?
}

// MARK: - LoadingWithModelCell
extension ApplePayTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        //self.titleLabel?.text       = self.model?.title
		//self.titleLabel?.setTextStyle(Theme.current.paymentOptionsCellStyle.web.titleStyle)
		
        self.iconImageView?.image   = self.model?.iconImage
       // self.arrowImageView?.image  = self.model?.arrowImage
    }
}
