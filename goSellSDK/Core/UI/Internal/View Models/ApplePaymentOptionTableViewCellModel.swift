//
//  ApplePaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

import TapCardVlidatorKit_iOS
import class TapNetworkManagerV2.TapImageLoader
import class UIKit.UIImage.UIImage
import enum PassKit.PKPaymentButtonType
import enum PassKit.PKPaymentButtonStyle
import class PassKit.PKPaymentAuthorizationViewController
import struct PassKit.PKPaymentNetwork

internal class ApplePaymentOptionTableViewCellModel: PaymentOptionTableCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var title: String {
        
        return self.paymentOption.title
    }
    
    internal var iconImageURL: URL {
        
        return self.paymentOption.imageURL
    }
    
    internal override var paymentOption: PaymentOption {
        
        return self.storedPaymentOption
    }
    
    internal private(set) var iconImage: UIImage?
    
    internal weak var cell: ApplePayTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    internal var arrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
    }
    
    internal override var isReadyForPayment: Bool {
        
        return true
    }
    
    internal override var affectsPayButtonState: Bool {
        
        return false
    }
    
    internal override var initiatesPaymentOnSelection: Bool {
        
        return true
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, paymentOption: PaymentOption) {
        
        self.storedPaymentOption = paymentOption
        
        super.init(indexPath: indexPath)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let storedPaymentOption: PaymentOption
    
    // MARK: Methods
    
    private func loadImageAndUpdateCell() {
        
        TapImageLoader.shared.downloadImage(from: self.iconImageURL) { [weak self] (image, _) in
            
            guard let strongSelf = self else { return }
            
            if let nonnullImage = image {
                
                strongSelf.iconImage = nonnullImage
                strongSelf.updateCell()
            }
        }
    }
    
    
    internal var applePayMappedSupportedNetworks: [PKPaymentNetwork] {
        get{
            var applePayMappedSupportedNetworks:[PKPaymentNetwork] = []
            applePayMappedSupportedNetworks.append(contentsOf: paymentOption.applePayNetworkMapper())
            return applePayMappedSupportedNetworks.removingDuplicates()
        }
    }
}

// MARK: - SingleCellModel
extension ApplePaymentOptionTableViewCellModel: SingleCellModel {
    
    func applePayButtonType() -> PKPaymentButtonType
    {
        var applPayButtonType:PKPaymentButtonType = .plain
        if #available(iOS 10.0, *) {
            applPayButtonType = .inStore
        }
        
        /*if let session = Process.shared.externalSession, let sessionDatSource = session.dataSource
        {
            if let dataSourceApplePayButtonType = sessionDatSource.applePayButtonType
            {
                applPayButtonType = dataSourceApplePayButtonType
            }
        }*/
        // First we check if we need to show setup pay
        let supportedNetworks = self.applePayMappedSupportedNetworks
        if PKPaymentAuthorizationViewController.canMakePayments()
        {
            if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks)
            {
                applPayButtonType = .setUp
            }
        }
        return applPayButtonType
    }
    
    
    func applePayButtonTypeStyle() -> PKPaymentButtonStyle
    {
        // First we set the default apple pay button style
        var applPayButtonStyle:PKPaymentButtonStyle = .whiteOutline
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark
            {
                applPayButtonStyle = .white
            }
       }
        
        if let session = Process.shared.externalSession, let sessionDatSource = session.dataSource
        {
            if let dataSourceApplePayStyle = sessionDatSource.applePayButtonStyle
            {
                applPayButtonStyle = dataSourceApplePayStyle
            }
        }
        
        return applPayButtonStyle
    }
}
