//
//  UINavigationControllerPopInteractionController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import func     TapAdditionsKit.clamp
import class    UIKit.UIGestureRecognizer.UIGestureRecognizer
import protocol UIKit.UIGestureRecognizer.UIGestureRecognizerDelegate
import class    UIKit.UIScreenEdgePanGestureRecognizer.UIScreenEdgePanGestureRecognizer
import class    UIKit.UIViewController.UIViewController
import class    UIKit.UIViewControllerTransitioning.UIPercentDrivenInteractiveTransition

internal final class UINavigationControllerPopInteractionController: BaseInteractionController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override var delegate: InteractiveTransitionControllerDelegate? {
        
        get {
            
            return self.manualStatusListener ?? self.defaultStatusListener
        }
        set {
            
            self.manualStatusListener = newValue
        }
    }
    
    // MARK: Methods
    
    internal init(viewController: UIViewController & InteractivePopViewController) {
        
        self.viewController = viewController
        
        super.init()
        
        self.setupGestureRecognizer()
    }
    
    internal override func callDismissOrPop(_ animated: Bool) {
        
        self.viewController.navigationController?.popViewController(animated: animated)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let edgeTranslationPercentageToFinishTransition: CGFloat = 0.5
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private weak var manualStatusListener: InteractiveTransitionControllerDelegate?
    
    private var defaultStatusListener: InteractiveTransitionControllerDelegate? {
        
        return self.viewController as? InteractiveTransitionControllerDelegate
    }
    
    private var shouldCompleteTransitionOnGestureFinish: Bool = false
    
    private unowned let viewController: UIViewController & InteractivePopViewController
    
    // MARK: Methods
    
    private func setupGestureRecognizer() {
        
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanDetected(_:)))
        recognizer.delegate = self
        recognizer.edges = SettingsDataManager.shared.layoutDirection == .leftToRight ? .left : .right
        
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
                
                self.tryToFinish()
            }
            else {
                
                self.cancel()
            }
            
        default:
            
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension UINavigationControllerPopInteractionController: UIGestureRecognizerDelegate {
    
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return self.delegate?.canStartInteractiveTransition ?? true
    }
}
