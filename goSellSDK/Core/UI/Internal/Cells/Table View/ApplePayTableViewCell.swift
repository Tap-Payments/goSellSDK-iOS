//
//  ApplePayTableViewCell.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
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
import enum PassKit.PKPaymentButtonStyle

internal class ApplePayTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: ApplePaymentOptionTableViewCellModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    //@IBOutlet private weak var titleLabel:      UILabel?
    @IBOutlet private weak var iconImageView:   UIImageView?
    
    // MARK: - Private -
    // MARK: Properties
    
    private var applePayButton: PKPaymentButton?
    private var applePayButtonConfiguration: (type: PKPaymentButtonType, style: PKPaymentButtonStyle)?
    
    // MARK: Methods
    
    /// Shows one Apple Pay button, pinned to the cell's width with Auto Layout so it follows size changes
    /// (rotation, folding). A PKPaymentButton's type and style can't change after it is created, so the
    /// button is only replaced when they change, instead of adding a new one on every update.
    private func showApplePayButton(type: PKPaymentButtonType, style: PKPaymentButtonStyle) {
        
        if self.applePayButton != nil, let configuration = self.applePayButtonConfiguration, configuration.type == type, configuration.style == style {
            
            return
        }
        
        self.applePayButton?.removeFromSuperview()
        
        let applePayButton = PKPaymentButton(paymentButtonType: type, paymentButtonStyle: style)
        applePayButton.layer.cornerRadius = 4
        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        applePayButton.addTarget(self, action: #selector(self.applePayButtonClicked(_:)), for: .touchUpInside)
        self.contentView.addSubview(applePayButton)
        
        NSLayoutConstraint.activate([
            applePayButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            applePayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            applePayButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            applePayButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.applePayButton = applePayButton
        self.applePayButtonConfiguration = (type, style)
    }
    //@IBOutlet private weak var arrowImageView:  UIImageView?
}

// MARK: - LoadingWithModelCell
extension ApplePayTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        DispatchQueue.main.async {
            
            self.iconImageView?.image   = self.model?.iconImage
            
            var defaultApplePayType:PKPaymentButtonType = .plain
            if #available(iOS 10.0, *) {
                defaultApplePayType = .inStore
            }
            
            let applPayButtonType:PKPaymentButtonType = self.model?.applePayButtonType() ??  defaultApplePayType
            self.showApplePayButton(type: applPayButtonType, style: self.model?.applePayButtonTypeStyle() ?? .black)
            
            self.backgroundColor = UIColor.clear
            
            let enableApplePaySetup = Process.shared.externalSession?.dataSource?.enableApplePaySetup ?? false
            if !enableApplePaySetup {
                self.isHidden = !ApplePayAvailability.canMakePayments
            } else {
                self.isHidden = false // Always show when setup is enabled
            }
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
