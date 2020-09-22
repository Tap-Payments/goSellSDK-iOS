//
//  OTPInputView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import class    TapEditableViewV2.TapEditableView
import class    TapNibViewV2.TapNibView
import class    UIKit.UIEvent.UIEvent
import class    UIKit.UILabel.UILabel
import protocol UIKit.UITextInput.UIKeyInput
import protocol UIKit.UITextInput.UITextInput
import protocol UIKit.UITextInput.UITextInputDelegate
import class    UIKit.UITextInput.UITextInputStringTokenizer
import protocol UIKit.UITextInput.UITextInputTokenizer
import enum     UIKit.UITextInput.UITextLayoutDirection
import class    UIKit.UITextInput.UITextPosition
import class    UIKit.UITextInput.UITextRange
import class    UIKit.UITextInput.UITextSelectionRect
import enum     UIKit.UITextInput.UITextStorageDirection
import enum     UIKit.UITextInput.UITextWritingDirection
import enum     UIKit.UITextInputTraits.UIKeyboardType
import struct   UIKit.UITextInputTraits.UITextContentType
import protocol UIKit.UITextInputTraits.UITextInputTraits
import class    UIKit.UITouch.UITouch
import enum		UIKit.UIView.UISemanticContentAttribute
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
    
    internal override var canResignFirstResponder: Bool {
        
        return true
    }
    
    internal var otp: String {
        
        get {
            
            return self.otpCode
        }
        set {
            
            self.setOTPCode(newValue, wholeAtOnce: false)
        }
    }
	
	@available(iOS 9.0, *)
	internal override var semanticContentAttribute: UISemanticContentAttribute {
		
		get {
			
			return .forceLeftToRight
		}
		set {}
	}
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
        
        let initialTextTransform = CGAffineTransform(scaleX: Constants.minTextZoomScale, y: Constants.minTextZoomScale)
        self.otpLabels?.forEach { $0.transform = initialTextTransform }
    }
    
    internal func startEditing() {
        
        guard let nonnullWindow = self.window else { return }
        
        if !nonnullWindow.isKeyWindow {
            
            if nonnullWindow.isHidden {
                
                nonnullWindow.makeKeyAndVisible()
            }
            else {
                
                nonnullWindow.makeKey()
            }
        }
        
        self.becomeFirstResponder()
    }
    
    internal override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            if self.bounds.contains(touch.location(in: self)) {
                
                self.startEditing()
                break
            }
        }
    }
	
	internal func setDigitsStyle(_ style: TextStyle) {
		
		self.otpLabels?.forEach { $0.setTextStyle(style) }
	}
    
    internal func setDigitsHolderViewBackgroundColor(_ color:UIColor) {
        
        self.otpDigitsView?.forEach { $0.backgroundColor = color }
    }
    
    internal func setDigitsHolderBorderColor(_ color:UIColor) {
        
        self.otpDigitsView?.forEach { $0.tap_borderColor = color }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let otpCodeLength:                           Int             = 6
        fileprivate static let textChangeAnimationDuration:             TimeInterval    = 0.25
        fileprivate static let textAppearanceAnimationRelativePoint:    Double          = 2.0 / 3.0
        fileprivate static let maxTextZoomScale:                        CGFloat         = 1.6
        fileprivate static let minTextZoomScale:                        CGFloat         = 0.2
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private var otpLabels: [UILabel]?
    @IBOutlet private var otpDigitsView: [UIView]?
    
    private var otpCode: String = ""
    
    private lazy var inputTokenizer: UITextInputTokenizer = UITextInputStringTokenizer(textInput: self)
    private weak var textInputDelegate: UITextInputDelegate?
    private var textDirection: UITextWritingDirection = .leftToRight
    
    private var displayedOTPCode: String {
        
        guard let nonnullOTPLabels = self.otpLabels else { return .tap_empty }
        
        let orderedOTPLabels = nonnullOTPLabels.sorted { $0.tag < $1.tag }
        let texts = orderedOTPLabels.map { $0.text ?? .tap_empty }
        
        return texts.joined()
    }
    
    private var lastInputState: Bool?
    
    private var currentInputState: Bool {
        
        return self.otp.tap_length == Constants.otpCodeLength
    }
    
    // MARK: Methods
    
    private func setOTPCode(_ code: String, wholeAtOnce: Bool) {
        
        defer {
            
            let currentState = self.currentInputState
            
            if currentState != self.lastInputState {
                
                self.delegate?.otpInputView(self, inputStateChanged: currentState, wholeOTPAtOnce: wholeAtOnce)
            }
        }
        
        self.otpCode = code
        
        let truncatedCode = String(code.prefix(Constants.otpCodeLength))
        let texts = truncatedCode.map { String($0) }
        let length = truncatedCode.tap_length
        
        self.otpLabels?.enumerated().forEach {
            
            let desiredText = $0.offset < length ? texts[$0.offset] : .tap_empty
            let previousText = $0.element.text ?? .tap_empty
            
            self.animateLabelTextChange($0.element, from: previousText, to: desiredText)
        }
    }
    
    private func animateLabelTextChange(_ label: UILabel, from: String, to: String) {
        
        guard from != to else { return }
        
        let appearance = from.tap_length < to.tap_length
        
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
        let options: UIView.KeyframeAnimationOptions = [.beginFromCurrentState, .calculationModeLinear]
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

            if #available(iOS 10.0, *) {
                
                return .asciiCapableNumberPad
            }
            else {
                
                return .numberPad
            }
        }
        set {}
    }
    
    @available(iOS 10.0, *)
    internal var textContentType: UITextContentType! {

        get {

            if #available(iOS 12.0, *) {
                
                return .oneTimeCode
            }
            else {
                
                return nil
            }
        }
        set {}
    }
}

// MARK: - UIKeyInput
extension OTPInputView: UIKeyInput {
    
    internal var hasText: Bool {
        
        return self.otp.tap_length > 0
    }
    
    internal func insertText(_ text: String) {
        
        guard text.tap_containsOnlyInternationalDigits else { return }
        if text.tap_length == Constants.otpCodeLength {
            
            self.setOTPCode(text, wholeAtOnce: true)
        }
        else if text.tap_length == 1 && self.otp.tap_length < Constants.otpCodeLength {
            
            self.otp += text
        }
    }
    
    internal func deleteBackward() {
        
        guard self.hasText else { return }
        self.otp = String(self.otp.dropLast())
    }
}

// MARK: - UITextInput
extension OTPInputView: UITextInput {
	
	#if swift(>=4.2)
	
	internal var markedTextStyle: [NSAttributedString.Key : Any]? {
	
		get {
	
			return nil
		}
		set {}
	}
	
	internal func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		
		return self.tap_selectionRects(for: range)
	}
	
	#else
	
	internal var markedTextStyle: [AnyHashable : Any]? {
		
		get {
			
			return nil
		}
		set {}
	}

	internal func selectionRects(for range: UITextRange) -> [Any] {
		
		return self.tap_selectionRects(for: range)
	}
	
	#endif
	
    internal func text(in range: UITextRange) -> String? {
        
        let nsRange = self.convertToNSRange(range)
        return self.otp.tap_substring(with: nsRange)
    }
    
    internal func replace(_ range: UITextRange, withText text: String) {
        
        let nsRange = self.convertToNSRange(range)
        self.otp.tap_replace(range: nsRange, withString: text)
    }
    
    internal var selectedTextRange: UITextRange? {
        
        get {
            
            guard let start = self.position(from: self.beginningOfDocument, offset: self.otp.tap_length) else { return nil }
            return self.textRange(from: start, to: start)
        }
        set {}
    }
    
    internal var markedTextRange: UITextRange? {
        
        return nil
    }
    
    internal func setMarkedText(_ markedText: String?, selectedRange: NSRange) {}
    
    internal func unmarkText() {}
    
    internal var beginningOfDocument: UITextPosition {

        return TextPosition(position: 0)!
    }
    
    internal var endOfDocument: UITextPosition {
        
        return TextPosition(position: max(self.otp.tap_length - 1, 0))!
    }
    
    internal func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        
        guard let from = fromPosition as? TextPosition, let to = toPosition as? TextPosition else { return nil }
        return TextRange(start: from, end: to)
    }
    
    internal func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        
        guard let from = position as? TextPosition else { return nil }
        return TextPosition(position: from.position + offset)
    }
    
    internal func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        
        return self.position(from: position, offset: offset)
    }
    
    internal func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        
        guard let from = position as? TextPosition, let to = other as? TextPosition else { return .orderedSame }
    
        return from.position == to.position ? .orderedSame : from.position < to.position ? .orderedAscending : .orderedDescending
    }
    
    internal func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        
        guard let start = from as? TextPosition, let end = toPosition as? TextPosition else { return 0 }
        
        return end.position - start.position
    }
    
    internal var inputDelegate: UITextInputDelegate? {
        
        get {
            
            return self.textInputDelegate
        }
        set {
            
            self.textInputDelegate = newValue
        }
    }
    
    internal var tokenizer: UITextInputTokenizer {
        
        return self.inputTokenizer
    }
    
    internal func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        
        switch direction {
            
        case .left, .up:    return range.start
        case .right, .down: return range.end
            
		@unknown default:	return range.start

		}
    }
    
    internal func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
        
        guard let pos = position as? TextPosition else { return nil }
        return TextRange(start: pos, end: pos)
    }
    
    internal func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> UITextWritingDirection {
        
        return self.textDirection
    }
    
    internal func setBaseWritingDirection(_ writingDirection: UITextWritingDirection, for range: UITextRange) {
        
        self.textDirection = writingDirection
    }
    
    internal func firstRect(for range: UITextRange) -> CGRect {
        
        return self.otpLabelsBoundingRect(for: range)
    }
    
    internal func caretRect(for position: UITextPosition) -> CGRect {
        
        guard let start = position as? TextPosition else { return .zero }
        return self.otpLabelRect(at: start.position)
    }
    
    internal func closestPosition(to point: CGPoint) -> UITextPosition? {
        
        guard let labels = self.otpLabels, labels.count > 0 else { return nil }
        var rects: [CGRect] = []
        for index in 0..<labels.count {
            
            rects.append(self.otpLabelRect(at: index))
        }
        
        let rectCenters = rects.map { CGPoint(x: $0.midX, y: $0.midY) }
        let distancePoints = rectCenters.map { $0.tap_subtract(point) }
        let distances = distancePoints.map { sqrt($0.x * $0.x + $0.y * $0.y) }
        
        var minimalDistanceIndex = 0
        var minimalDistance = distances[0]
        
        for (index, distance) in distances.enumerated() {
            
            if distance < minimalDistance {
                
                minimalDistance         = distance
                minimalDistanceIndex    = index
            }
        }
        
        return TextPosition(position: minimalDistanceIndex)
    }
    
    internal func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        
        guard let position = self.closestPosition(to: point) as? TextPosition else { return nil }
        guard let start = range.start as? TextPosition, let end = range.end as? TextPosition else {return nil }
        
        if position.position < start.position {
            
            return start
        }
        
        if position.position > end.position {
            
            return end
        }
        
        return position
    }
    
    internal func characterRange(at point: CGPoint) -> UITextRange? {
        
        guard let position = self.closestPosition(to: point) as? TextPosition else { return nil }
        
        return TextRange(start: position, end: position)
    }
    
    private func convertToNSRange(_ textRange: UITextRange) -> NSRange {
        
        let beginning = self.beginningOfDocument
        let start = self.offset(from: beginning, to: textRange.start)
        let length = self.offset(from: textRange.start, to: textRange.end)
        
        let nsRange = NSRange(location: start, length: length)
        
        return nsRange
    }
    
    private func otpLabelsBoundingRect(for range: UITextRange) -> CGRect {
        
        guard let start = range.start as? TextPosition, let end = range.end as? TextPosition else { return .zero }
        
        var indexes: [Int] = []
        var index: Int = start.position
        while index <= end.position {
            
            indexes.append(index)
            index += 1
        }
        
        let rects = indexes.map { self.otpLabelRect(at: $0) }
        guard rects.count > 0 else { return .zero }
        
        return rects.reduce(rects[0]) { self.boundingBox($0, $1) }
    }
    
    private func otpLabelRect(at index: Int) -> CGRect {
        
        guard let labels = self.otpLabels, labels.count > index, index > -1 else { return .zero }
        
        let label = labels[index]
        return label.convert(label.bounds, to: self)
    }
    
    private func boundingBox(_ rect1: CGRect, _ rect2: CGRect) -> CGRect {
        
        let minX = min(rect1.minX, rect2.minX)
        let minY = min(rect1.minY, rect2.minY)
        let maxX = max(rect1.maxX, rect2.maxX)
        let maxY = max(rect1.maxY, rect2.maxY)
        
        return CGRect(x: minX, y: minY, width: maxX - minX + 1.0, height: maxY - minY + 1.0)
    }
	
	private func tap_selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		
		guard let tapRange = range as? TextRange else { return [] }
		
		let rect = self.otpLabelsBoundingRect(for: range)
		let selectionRect = TextSelectionRect(inputView: self, rect: rect, writingDirection: self.textDirection, range: tapRange)
		
		return [selectionRect]
	}
}

private extension OTPInputView {
    
    private class TextPosition: UITextPosition {
        
        fileprivate let position: Int
        
        fileprivate init?(position: Int) {
            
            guard position > -1 else { return nil }
            
            self.position = position
        }
    }
    
    private class TextRange: UITextRange {
        
        private let _start: TextPosition
        private let _end: TextPosition
        
        fileprivate override var start: UITextPosition { return self._start }
        fileprivate override var end: UITextPosition { return self._end }
        fileprivate override var isEmpty: Bool { return self._start.position == self._end.position }
        
        fileprivate init?(start: TextPosition, end: TextPosition) {
            
            guard start.position <= end.position else { return nil }
            
            self._start = start
            self._end   = end
            
            super.init()
        }
    }
    
    private class TextSelectionRect: UITextSelectionRect {
        
        private let _rect: CGRect
        private let _writingDirection: UITextWritingDirection
        private let range: TextRange
        private weak var inputView: OTPInputView?
        
        fileprivate override var rect: CGRect { return self._rect }
        fileprivate override var writingDirection: UITextWritingDirection { return self._writingDirection }
        
        fileprivate override var containsStart: Bool { return (self.range.start as? TextPosition)?.position == 0 }
        fileprivate override var containsEnd: Bool { return (self.range.end as? TextPosition)?.position == self.inputView?.otp.tap_length }
        fileprivate override var isVertical: Bool { return false }
        
        fileprivate init(inputView: OTPInputView, rect: CGRect, writingDirection: UITextWritingDirection, range: TextRange) {
            
            self.inputView          = inputView
            self._rect              = rect
            self._writingDirection  = writingDirection
            self.range              = range
            
            super.init()
        }
    }
}
