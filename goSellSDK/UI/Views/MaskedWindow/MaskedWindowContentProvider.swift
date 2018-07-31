//
//  MaskedWindowContentProvider.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class    UIKit.UIView.UIView

internal protocol MaskedWindowContentProvider: ClassProtocol {
    
    var mask: UIView { get }
}
