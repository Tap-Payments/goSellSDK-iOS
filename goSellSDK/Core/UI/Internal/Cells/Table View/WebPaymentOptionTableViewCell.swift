//
//  WebPaymentOptionTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView

internal class WebPaymentOptionTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: WebPaymentOptionTableViewCellModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleLabel:      UILabel?
    @IBOutlet private weak var iconImageView:   UIImageView?
    @IBOutlet private weak var arrowImageView:  UIImageView?
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var paddingView: UIView!
}

// MARK: - LoadingWithModelCell
extension WebPaymentOptionTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        DispatchQueue.main.async {

            self.titleLabel?.text       = self.model?.title
            self.titleLabel?.setTextStyle(Theme.current.paymentOptionsCellStyle.web.titleStyle)
            
            self.iconImageView?.image   = self.model?.iconImage
            self.arrowImageView?.image  = self.model?.arrowImage
            
            self.iconImageView?.translatesAutoresizingMaskIntoConstraints = false
            self.iconViewWidthConstraint.constant = 32
            
            if #available(iOS 13.0, *) {
               if UITraitCollection.current.userInterfaceStyle == .dark {
                self.paddingView.layer.cornerRadius = 8
                self.paddingView.layer.masksToBounds = true
                self.iconViewWidthConstraint.constant = 22
               }else{
                self.paddingView.layer.cornerRadius = 0
                self.paddingView.layer.masksToBounds = true
                self.iconViewWidthConstraint.constant = 32
                }
            }
        
        
            self.layoutIfNeeded()
            self.iconImageView?.layoutIfNeeded()
        }
    }
}
