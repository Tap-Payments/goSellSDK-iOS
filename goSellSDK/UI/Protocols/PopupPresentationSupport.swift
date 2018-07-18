//
//  PopupPresentationSupport.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIView.UIView

internal protocol PopupPresentationSupport {
    
    var presentationAnimationAnimatingConstraint: NSLayoutConstraint? { get }
    var viewToLayout: UIView { get }
}
