//
//  MerchantInformationHeaderViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

/// Merhant information header view controller delegate.
internal protocol MerchantInformationHeaderViewControllerDelegate: ClassProtocol {
    
    /// Notifies delegate that closed button clicked.
    ///
    /// - Parameter controller: Sender.
    func merchantInformationHeaderViewControllerCloseButtonClicked(_ controller: MerchantInformationHeaderViewController)
}
