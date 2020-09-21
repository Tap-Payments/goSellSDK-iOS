//
//  BaseInteractionController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    UIKit.UIViewControllerTransitioning.UIPercentDrivenInteractiveTransition

internal class BaseInteractionController: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var isInteracting: Bool = false
    
    internal weak var delegate: InteractiveTransitionControllerDelegate?
    
    // MARK: Methods
    
    internal func begin() {
        
        DispatchQueue.main.async {
            
            self.delegate?.interactiveTransitionWillBegin?()
            self.isInteracting = true
            self.callDismissOrPop(true)
            self.delegate?.interactiveTransitionDidBegin?()
        }
    }
    
    internal override func update(_ percentComplete: CGFloat) {
        
        self.delegate?.interactiveTransitionWillChangeProgress?(percentComplete)
        super.update(percentComplete)
        self.delegate?.interactiveTransitionDidChangeProgress?(percentComplete)
    }
    
    @available(iOS 10.0, *)
    internal override func pause() {
        
        self.delegate?.interactiveTransitionWillPause?()
        super.pause()
        self.delegate?.interactiveTransitionDidPause?()
    }
    
    internal override func finish() {
        
        self.delegate?.interactiveTransitionWillFinish?()
        self.isInteracting = false
        super.finish()
        self.delegate?.interactiveTransitionDidFinish?()
    }
    
    internal func tryToFinish() {
        
        guard let nonnullDelegate = self.delegate else {
            
            self.finish()
            return
        }
        
        if nonnullDelegate.responds(to: #selector(InteractiveTransitionControllerDelegate.canFinishInteractiveTransition(_:))) {
            
            nonnullDelegate.canFinishInteractiveTransition? { (willFinish) in
                
                if willFinish {
                    
                    self.finish()
                }
                else {
                    
                    self.cancel()
                }
            }
        }
        else {
            
            self.finish()
        }
    }
    
    internal override func cancel() {
        
        self.delegate?.interactiveTransitionWillCancel?()
        self.isInteracting = false
        super.cancel()
        self.delegate?.interactiveTransitionDidCancel?()
    }
    
    internal func callDismissOrPop(_ animated: Bool) {
        
        fatalError("Should be implemented in subclassed")
    }
}
