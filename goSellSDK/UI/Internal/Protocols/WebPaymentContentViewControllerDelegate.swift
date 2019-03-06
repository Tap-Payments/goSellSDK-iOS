//
//  WebPaymentContentViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import protocol TapAdditionsKit.ClassProtocol

internal protocol WebPaymentContentViewControllerDelegate: ClassProtocol {
    
    func webPaymentContentViewControllerRequestedDismissal(_ controller: WebPaymentContentViewController)
}
