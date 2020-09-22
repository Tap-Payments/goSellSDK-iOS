//
//  InteractiveTransitionControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias

@objc internal protocol InteractiveTransitionControllerDelegate: NSObjectProtocol {
    
    @objc optional var canStartInteractiveTransition: Bool { get }
    @objc optional func canFinishInteractiveTransition(_ decision: @escaping TypeAlias.BooleanClosure)
    
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
