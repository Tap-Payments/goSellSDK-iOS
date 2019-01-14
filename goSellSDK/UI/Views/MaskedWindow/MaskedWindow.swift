//
//  MaskedWindow.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import class    UIKit.UIEvent.UIEvent
import class    UIKit.UIView.UIView
import class    UIKit.UIWindow.UIWindow

internal class MaskedWindow: UIWindow {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var contentProvider: MaskedWindowContentProvider?
    
    // MARK: Methods
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let result = super.hitTest(point, with: event)
        
        guard let nonnullMask = self.contentProvider?.mask else { return result }
        
        let pointInView = self.convert(point, to: nonnullMask)
        if nonnullMask.bounds.contains(pointInView) {
            
            return result
        }
        
        return nil
    }
}
