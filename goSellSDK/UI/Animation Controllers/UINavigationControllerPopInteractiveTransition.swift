//
//  UINavigationControllerPopInteractiveTransition.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import func     TapAdditionsKit.clamp
import class    UIKit.UIScreenEdgePanGestureRecognizer.UIScreenEdgePanGestureRecognizer
import class    UIKit.UIViewController.UIViewController
import class    UIKit.UIViewControllerTransitioning.UIPercentDrivenInteractiveTransition

internal final class UINavigationControllerPopInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var isInteracting: Bool = false
    
    // MARK: Methods
    
    internal init(viewController: UIViewController & InteractivePopViewController) {
        
        self.viewController = viewController
        
        super.init()
        
        self.setupGestureRecognizer()
    }
    
    internal func begin() {
        
        DispatchQueue.main.async {
            
            self.statusListener?.interactiveTransitionWillBegin?()
            self.isInteracting = true
            self.viewController.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let edgeTranslationPercentageToFinishTransition: CGFloat = 0.5
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var shouldCompleteTransitionOnGestureFinish: Bool = false
    
    private unowned let viewController: UIViewController & InteractivePopViewController
    
    private var statusListener: InteractivePopViewControllerStatusReporting? {
        
        return self.viewController as? InteractivePopViewControllerStatusReporting
    }
    
    // MARK: Methods
    
    private func setupGestureRecognizer() {
        
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanDetected(_:)))
        
        // FIXME: Add RTL support.
        recognizer.edges = .left
        
        self.viewController.view.addGestureRecognizer(recognizer)
    }
    
    @objc private func screenEdgePanDetected(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            
            self.begin()
            
        case .changed:
            
            let translation             = recognizer.translation(in: recognizer.view?.window).x
            let velocity                = recognizer.velocity(in: recognizer.view?.window).x
            let maxTranslation          = self.viewController.view.bounds.size.width
            let edgeTranslation         = maxTranslation * Constants.edgeTranslationPercentageToFinishTransition
            let animationProgress       = clamp(value: translation / maxTranslation, low: 0.0, high: 1.0)
            let translationIfReleased   = translation + velocity * self.duration
            
            self.shouldCompleteTransitionOnGestureFinish = translationIfReleased >= edgeTranslation
            self.update(animationProgress)
            
        case .cancelled:
            
            self.cancel()
            
        case .ended:
            
            if self.shouldCompleteTransitionOnGestureFinish {
                
                self.finish()
            }
            else {
                
                self.cancel()
            }
            
        default:
            
            break
        }
    }
}
