//
//  TapNavigationViewDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

/// Delegate for TapNavigationView class.
internal protocol TapNavigationViewDelegate: ClassProtocol {
	
    /// Notifies the receiver that back button was clicked.
    ///
    /// - Parameter navigationView: Sender.
    func navigationViewBackButtonClicked(_ navigationView: TapNavigationView)
	
	/// Notifies the receiver that close button was clicked.
	///
	/// - Parameter navigationView: Sender.
	func navigationViewCloseButtonClicked(_ navigationView: TapNavigationView)
}
