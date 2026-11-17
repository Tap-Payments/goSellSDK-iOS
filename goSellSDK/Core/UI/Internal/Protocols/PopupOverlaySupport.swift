//
//  PopupOverlaySupport.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import protocol TapAdditionsKitV2.ClassProtocol
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIView.UIView

internal protocol PopupOverlaySupport: ClassProtocol {
    
    var topOffsetOverlayConstraint: NSLayoutConstraint? { get }
	var bottomOffsetOverlayConstraint: NSLayoutConstraint? { get }
	var bottomOverlayView: UIView? { get }
    var layoutView: UIView { get }
    
    func additionalAnimations(for operation: ViewControllerOperation) -> TypeAlias.ArgumentlessClosure
}
