//
//  WobblingViewHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    QuartzCore.CAAnimation.CAKeyframeAnimation
import var      QuartzCore.CAMediaTiming.kCAFillModeForwards
import struct   QuartzCore.CATransform3D.CATransform3D
import func     QuartzCore.CATransform3D.CATransform3DMakeRotation
import class    UIKit.UIView.UIView

internal protocol WobblingViewHandler {
    
    var wobblingView: UIView { get }
}

internal extension WobblingViewHandler {
    
    func startWobbling(with angle: CGFloat = CGFloat.pi / 36.0, duration: TimeInterval = 0.3) {
        
        if self.wobblingView.layer.animation(forKey: WobblingConstants.wobbleAnimationKey) != nil {
        
            self.stopWobbling()
        }
        
        let timeOffset: Double = duration * TimeInterval(Float(arc4random()) / Float(UInt32.max))
        
        let wobbleAnimation: CAKeyframeAnimation    = CAKeyframeAnimation(keyPath: WobblingConstants.animationKeyPath)
        wobbleAnimation.values                      = self.wobbleAnimationValues(for: angle)
        wobbleAnimation.keyTimes                    = self.animationTimings
		
		#if swift(>=4.2)
        wobbleAnimation.fillMode                    = .forwards
		#else
		wobbleAnimation.fillMode					= kCAFillModeForwards
		#endif
		
        wobbleAnimation.isRemovedOnCompletion       = false
        wobbleAnimation.repeatCount                 = Float.greatestFiniteMagnitude
        wobbleAnimation.timeOffset                  = timeOffset
        wobbleAnimation.duration                    = duration
        
        self.wobblingView.layer.add(wobbleAnimation, forKey: WobblingConstants.wobbleAnimationKey)
    }
    
    func stopWobbling() {
        
        self.wobblingView.layer.removeAnimation(forKey: WobblingConstants.wobbleAnimationKey)
    }
    
    private var animationTimings: [NSNumber] { return [0.0, 0.25, 0.75, 1.0] }
    
    private func wobbleAnimationValues(for angle: CGFloat) -> [NSValue] {
        
        let value1: CATransform3D = CATransform3DMakeRotation(0.0,     0.0, 0.0, 1.0)
        let value2: CATransform3D = CATransform3DMakeRotation(-angle,  0.0, 0.0, 1.0)
        let value3: CATransform3D = CATransform3DMakeRotation(angle,   0.0, 0.0, 1.0)
        let value4: CATransform3D = CATransform3DMakeRotation(0.0,     0.0, 0.0, 1.0)

        return [
        
            NSValue(caTransform3D: value1),
            NSValue(caTransform3D: value2),
            NSValue(caTransform3D: value3),
            NSValue(caTransform3D: value4)
        ]
    }
}

private struct WobblingConstants {
    
    fileprivate static let animationKeyPath: String     = "transform"
    fileprivate static let wobbleAnimationKey: String   = "wobble"
    
    //@available(*, unavailable) private init() { }
}
