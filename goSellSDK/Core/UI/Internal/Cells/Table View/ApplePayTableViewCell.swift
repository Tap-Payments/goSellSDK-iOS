//
//  ApplePayTableViewCell.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

import CoreGraphics
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView
import class PassKit.PKPaymentButton
import class PassKit.PKPaymentAuthorizationViewController
import class PassKit.PKPassLibrary
import enum PassKit.PKPaymentButtonType

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
        DispatchQueue.main.async {

            self.iconImageView?.image   = self.model?.iconImage
            var defaultApplePayType:PKPaymentButtonType = .plain
            if #available(iOS 10.0, *) {
                defaultApplePayType = .inStore
            }
            let applPayButtonType:PKPaymentButtonType = self.model?.applePayButtonType() ??  defaultApplePayType
            
            let applePayButton:PKPaymentButton = PKPaymentButton(paymentButtonType: applPayButtonType, paymentButtonStyle: self.model?.applePayButtonTypeStyle() ?? .black)
            
            //applePayButton.backgroundColor = .blue
            var frame:CGRect = applePayButton.frame
            frame.size.width = self.frame.width - 30
            frame.size.height = 40
            applePayButton.frame = frame
            //applePayButton.tap_borderColor = UIColor(tap_hex: "E1E1E1")
            //applePayButton.tap_borderWidth = 1
            applePayButton.layer.cornerRadius = 4
            
            applePayButton.center = self.contentView.center
            applePayButton.addTarget(self, action: #selector(self.applePayButtonClicked(_:)), for: .touchUpInside)
            self.contentView.addSubview(applePayButton)
            
           // self.arrowImageView?.image  = self.model?.arrowImage
            self.backgroundColor = UIColor.clear
            
            // Hide the apple pay button if the device is not supporting Apple pay at all
            self.isHidden = !PKPaymentAuthorizationViewController.canMakePayments()
            
        }
    }
    
    @objc private func applePayButtonClicked(_ sender: Any) {
        
        //guard let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: model!.indexPath) as? TableViewCellViewModel else { return }
        
        //model.tableViewDidSelectCell(model.)
        var defaultApplePayType:PKPaymentButtonType = .plain
        if #available(iOS 10.0, *) {
            defaultApplePayType = .inStore
        }
        let applPayButtonType:PKPaymentButtonType = model?.applePayButtonType() ??  defaultApplePayType
        if applPayButtonType == .setUp {
            Process.shared.closePayment(with: .cancelled, fadeAnimation: true, force: true) {
                DispatchQueue.main.async {
                    let library = PKPassLibrary()
                    library.openPaymentSetup()
                }
            }
            return
        }
        model?.tableViewDidSelectCell(model!.tableView!)
    }
}
