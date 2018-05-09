//
//  TapNavigationViewDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

/// Delegate for TapNavigationView class.
internal protocol TapNavigationViewDelegate: ClassProtocol {
    
    /// Notifies the receiver that cancel button was clicked.
    ///
    /// - Parameter navigationView: Sender.
    func navigationViewBackButtonClicked(_ navigationView: TapNavigationView)
}
