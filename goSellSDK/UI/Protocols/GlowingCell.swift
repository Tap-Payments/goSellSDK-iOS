//
//  GlowingCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol GlowingCell {
    
    var glowingView: UIView { get }
}

internal extension GlowingCell {
    
    internal func prepareForGlowing() {
        
        self.glowingView.layer.shadowColor = UIColor(hex: "#2ACE00FF")?.cgColor
        self.glowingView.layer.shadowOffset = .zero
        self.glowingView.layer.shadowRadius = 4.0
        self.glowingView.layer.shadowOpacity = 0.0
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
    
    private func createGlowingAnimation(_ startGlowing: Bool) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: GlowingCellConstants.glowAnimationKeyPath)
        animation.fromValue = self.glowingView.layer.shadowOpacity
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
