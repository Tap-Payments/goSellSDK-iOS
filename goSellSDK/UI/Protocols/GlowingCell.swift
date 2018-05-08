//
//  GlowingCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

/// Glowing Cell protocol.
internal protocol GlowingCell: ClassProtocol {
    
    /// View to which glowing animation will be added.
    var glowingView: UIView { get }
}

// MARK: - Default implementation
internal extension GlowingCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func prepareForGlowing() {
        
        self.glowingView.layer.shadowColor = UIColor(hex: "#2ACE00FF")?.cgColor
        self.glowingView.layer.shadowOffset = .zero
        self.glowingView.layer.shadowRadius = 4.0
        self.glowingView.layer.shadowOpacity = 0.0
    }
    
    internal func setGlowing(_ glowing: Bool) {
        
        if glowing {
            
            self.startGlowing()
        }
        else {
            
            self.stopGlowing()
        }
    }
    
    internal func startGlowing() {
        
        let animation = self.createGlowingAnimation(true)
        self.glowingView.layer.add(animation, forKey: GlowingCellConstants.glowAnimationKey)
        self.glowingView.layer.shadowOpacity = 1.0
    }
    
    internal func stopGlowing() {
        
        let animation = self.createGlowingAnimation(false)
        self.glowingView.layer.add(animation, forKey: GlowingCellConstants.glowAnimationKey)
        self.glowingView.layer.shadowOpacity = 0.0
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func createGlowingAnimation(_ startGlowing: Bool) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: GlowingCellConstants.glowAnimationKeyPath)
        animation.fromValue = self.glowingView.layer.presentation()?.shadowOpacity ?? (startGlowing ? 0.0 : 1.0)
        animation.toValue = startGlowing ? 1.0 : 0.0
        animation.duration = GlowingCellConstants.glowAnimationDuration
        animation.isRemovedOnCompletion = true
        
        return animation
    }
}

private struct GlowingCellConstants {
    
    fileprivate static let glowAnimationKeyPath = "shadowOpacity"
    fileprivate static let glowAnimationKey = "glow"
    fileprivate static let glowAnimationDuration: TimeInterval = 0.3
    
    @available(*, unavailable) private init() {}
}
