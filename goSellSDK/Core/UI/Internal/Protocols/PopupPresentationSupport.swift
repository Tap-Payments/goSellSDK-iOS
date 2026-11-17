//
//  PopupPresentationSupport.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIView.UIView

internal protocol PopupPresentationSupport {
    
    var presentationAnimationAnimatingConstraint: NSLayoutConstraint? { get }
    var viewToLayout: UIView { get }
}
