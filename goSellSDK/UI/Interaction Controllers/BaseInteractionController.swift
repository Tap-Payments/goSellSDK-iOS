//
//  BaseInteractionController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import class    UIKit.UIViewControllerTransitioning.UIPercentDrivenInteractiveTransition

internal class BaseInteractionController: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var isInteracting: Bool = false
    
    internal weak var statusListener: InteractiveTransitionControllerStatusReporting?
    
    // MARK: Methods
    
    internal func begin() {
        
        DispatchQueue.main.async {
            
            self.statusListener?.interactiveTransitionWillBegin?()
            self.isInteracting = true
            self.callDismissOrPop(true)
            self.statusListener?.interactiveTransitionDidBegin?()
        }
    }
    
    internal override func update(_ percentComplete: CGFloat) {
        
        self.statusListener?.interactiveTransitionWillChangeProgress?(percentComplete)
        super.update(percentComplete)
        self.statusListener?.interactiveTransitionDidChangeProgress?(percentComplete)
    }
    
    @available(iOS 10.0, *)
    internal override func pause() {
        
        self.statusListener?.interactiveTransitionWillPause?()
        super.pause()
        self.statusListener?.interactiveTransitionDidPause?()
    }
    
    internal override func finish() {
        
        self.statusListener?.interactiveTransitionWillFinish?()
        self.isInteracting = false
        super.finish()
        self.statusListener?.interactiveTransitionDidFinish?()
    }
    
    internal override func cancel() {
        
        self.statusListener?.interactiveTransitionWillCancel?()
        self.isInteracting = false
        super.cancel()
        self.statusListener?.interactiveTransitionDidCancel?()
    }
    
    internal func callDismissOrPop(_ animated: Bool) {
        
        fatalError("Should be implemented in subclassed")
    }
}
