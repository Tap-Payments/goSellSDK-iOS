//
//  OTPInputView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGAffineTransform.CGAffineTransform
import struct   CoreGraphics.CGBase.CGFloat
import struct   TapAdditionsKit.TypeAlias
import class    TapEditableView.TapEditableView
import class    TapNibView.TapNibView
import class    UIKit.UIEvent.UIEvent
import class    UIKit.UILabel.UILabel
import protocol UIKit.UITextInput.UIKeyInput
import enum     UIKit.UITextInputTraits.UIKeyboardType
import protocol UIKit.UITextInputTraits.UITextInputTraits
import class    UIKit.UITouch.UITouch
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions

internal final class OTPInputView: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: OTPInputViewDelegate?
    
    internal var isProvidedDataValid: Bool {
        
        return self.currentInputState
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    internal var otp: String {
        
        get {
            
            return self.otpCode
        }
        set {
            
            self.setOTPCode(newValue)
        }
    }
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
        
        let initialTextTransform = CGAffineTransform(scaleX: Constants.minTextZoomScale, y: Constants.minTextZoomScale)
        self.otpLabels?.forEach { $0.transform = initialTextTransform }
    }
    
    internal override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard !self.isFirstResponder else { return }
        
        for touch in touches {
            
            if self.bounds.contains(touch.location(in: self)) {
                
                self.becomeFirstResponder()
                break
            }
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let otpCodeLength:                           Int             = 6
        fileprivate static let textChangeAnimationDuration:             TimeInterval    = 0.25
        fileprivate static let textAppearanceAnimationRelativePoint:    Double          = 2.0 / 3.0
        fileprivate static let maxTextZoomScale:                        CGFloat         = 1.6
        fileprivate static let minTextZoomScale:                        CGFloat         = 0.2
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private var otpLabels: [UILabel]?
    
    private var otpCode: String = ""
    
    private var displayedOTPCode: String {
        
        guard let nonnullOTPLabels = self.otpLabels else { return .empty }
        
        let orderedOTPLabels = nonnullOTPLabels.sorted { $0.tag < $1.tag }
        let texts = orderedOTPLabels.map { $0.text ?? .empty }
        
        return texts.joined()
    }
    
    private var lastInputState: Bool?
    
    private var currentInputState: Bool {
        
        return self.otp.length == Constants.otpCodeLength
    }
    
    // MARK: Methods
    
    private func setOTPCode(_ code: String) {
        
        defer {
            
            let currentState = self.currentInputState
            
            if currentState != self.lastInputState {
                
                self.delegate?.otpInputView(self, inputStateChanged: currentState)
            }
        }
        
        self.otpCode = code
        
        let truncatedCode = String(code.prefix(Constants.otpCodeLength))
        let texts = truncatedCode.map { String($0) }
        let length = truncatedCode.length
        
        self.otpLabels?.enumerated().forEach {
            
            let desiredText = $0.offset < length ? texts[$0.offset] : .empty
            let previousText = $0.element.text ?? .empty
            
            self.animateLabelTextChange($0.element, from: previousText, to: desiredText)
        }
    }
    
    private func animateLabelTextChange(_ label: UILabel, from: String, to: String) {
        
        guard from != to else { return }
        
        let appearance = from.length < to.length
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            if appearance {
                
                self.animateTextAppearance(in: label)
            }
            else {
                
                self.animateTextDisappearance(in: label)
            }
        }
        
        if appearance {
            
            label.text = to
        }
        
        let duration = Constants.textChangeAnimationDuration
        let options: UIViewKeyframeAnimationOptions = [.beginFromCurrentState, .calculationModeLinear]
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: options, animations: animations) { _ in
            
            label.text = to
        }
    }
    
    private func animateTextAppearance(in label: UILabel) {
        
        let firstAnimationStart = 0.0
        let firstAnimationDuration = Constants.textAppearanceAnimationRelativePoint
        UIView.addKeyframe(withRelativeStartTime: firstAnimationStart, relativeDuration: firstAnimationDuration) {
            
            label.transform = CGAffineTransform(scaleX: Constants.maxTextZoomScale, y: Constants.maxTextZoomScale)
            label.alpha = 1.0
        }
        
        let secondAnimationStart = firstAnimationStart + firstAnimationDuration
        let secondAnimationDuration = 1.0 - secondAnimationStart
        UIView.addKeyframe(withRelativeStartTime: secondAnimationStart, relativeDuration: secondAnimationDuration) {
            
            label.transform = .identity
        }
    }
    
    private func animateTextDisappearance(in label: UILabel) {
        
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
            
            label.transform = CGAffineTransform(scaleX: Constants.minTextZoomScale, y: Constants.minTextZoomScale)
            label.alpha = 0.0
        }
    }
}

// MARK: - UITextInputTraits
extension OTPInputView: UITextInputTraits {
    
    internal var keyboardType: UIKeyboardType {
        
        get {
            
            return .numberPad
        }
        set {}
    }
}

// MARK: - UIKeyInput
extension OTPInputView: UIKeyInput {
    
    internal var hasText: Bool {
        
        return self.otp.length > 0
    }
    
    internal func insertText(_ text: String) {
        
        guard text.containsOnlyInternationalDigits && text.length == 1 && self.otp.length < Constants.otpCodeLength else { return }
        
        self.otp += text
    }
    
    internal func deleteBackward() {
        
        guard self.hasText else { return }
        self.otp = String(self.otp.dropLast())
    }
}
