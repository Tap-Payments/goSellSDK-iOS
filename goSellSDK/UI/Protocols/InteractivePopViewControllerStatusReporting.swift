//
//  InteractivePopViewControllerStatusReporting.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat

@objc internal protocol InteractivePopViewControllerStatusReporting: NSObjectProtocol, InteractivePopViewController {
    
    @objc optional func interactiveTransitionWillBegin()
    @objc optional func interactiveTransitionDidBegin()
    
    @objc optional func interactiveTransitionWillChangeProgress(_ progress: CGFloat)
    @objc optional func interactiveTransitionDidChangeProgress(_ progress: CGFloat)
    
    @available(iOS 10.0, *) @objc optional func interactiveTransitionWillPause()
    @available(iOS 10.0, *) @objc optional func interactiveTransitionDidPause()
    
    @objc optional func interactiveTransitionWillFinish()
    @objc optional func interactiveTransitionDidFinish()
    
    @objc optional func interactiveTransitionWillCancel()
    @objc optional func interactiveTransitionDidCancel()
}
