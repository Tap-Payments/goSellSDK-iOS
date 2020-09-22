//
//  OTPViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import enum		UIKit.UIApplication.UIStatusBarStyle
import class    UIKit.UIButton.UIButton
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIGestureRecognizer.UIGestureRecognizer
import class    UIKit.UIImage.UIImage
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UITapGestureRecognizer.UITapGestureRecognizer
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerInteractiveTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate
import class    TapVisualEffectViewV2.TapVisualEffectView

/// View controller that handles Tap OTP input.
internal final class OTPViewController: SeparateWindowViewController {
    
    // MARK: - Internal -
	// MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[.fullscreen].uiStatusBarStyle
	}
	
    // MARK: Methods
    
    internal static func show(with topOffset: CGFloat = 0.0, with phoneNumber: String, delegate: OTPViewControllerDelegate) {
        
        let controller = self.createAndSetupController()
        controller.delegate = delegate
        controller.phoneNumber = phoneNumber
        
        if controller.presentingViewController == nil {
            
            controller.showExternally(topOffset: topOffset)
        }
        else {
            
            controller.startAnotherAttempt()
        }
    }
    
    internal func addInteractiveDismissalRecognizer(_ recognizer: UIGestureRecognizer) {
        
        self.dismissalView?.addGestureRecognizer(recognizer)
    }
    
    internal override func hide(animated: Bool = true, async: Bool = true, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
        super.hide(animated: animated, async: async) {
            
            OTPViewController.destroyInstance()
			
			ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeWindowedBack {
				
				completion?()
			}
        }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.startFirstAttemptIfNotYetStarted()
    }
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		
		self.countdownDateFormatter.locale = LocalizationManager.shared.selectedLocale
		
		self.updateResendButtonTitle(with: self.timerDataManager.state)
		
		self.confirmationButton?.setLocalizedText(.btn_confirm_title)
		
		self.updateDescriptionLabelText()
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		let settings = Theme.current.otpScreenStyle
		
		self.otpInputView?.setDigitsStyle(settings.digits)
        self.otpInputView?.setDigitsHolderViewBackgroundColor(settings.otpDigitsBackgroundColor.color)
        self.otpInputView?.setDigitsHolderBorderColor(settings.otpDigitsBorderColor.color)
		self.updateDescriptionLabelText()
		self.updateResendButtonTitle(with: self.timerDataManager.state)
		self.dismissalArrowImageView?.image = settings.arrowIcon
        blurView.style = Theme.current.commonStyle.blurStyle[Process.shared.appearance].style
	}
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ThemeManager.shared.resetCurrentThemeToDefault()
        themeChanged()
    }
	
    deinit {
        
        self.transitioning = nil
        self.timerDataManager.invalidateTimer()
    }
    
    // MARK: - Fileprivate -
    // MARK: Properties
    
    fileprivate var dismissalInteractionController: OTPDismissalInteractionController?
    
    // MARK: - Private -
    
    /// Transition handler for OTP view controller.
    private final class Transitioning: NSObject, UIViewControllerTransitioningDelegate {
        
        fileprivate var shouldUseDefaultOTPAnimation = true
        
        fileprivate func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if let otpController = presented as? OTPViewController {
                
                let interactionController = OTPDismissalInteractionController(viewController: otpController)
                otpController.dismissalInteractionController = interactionController
            }
            
            guard let to = presented as? PopupPresentationAnimationController.PopupPresentationViewController else { return nil }

			return PopupPresentationAnimationController(presentationFrom: presenting,
														to: to,
														overlaysFromView: false,
														overlaySupport: PaymentOptionsViewController.tap_findInHierarchy())
        }
        
        fileprivate func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            guard let from = dismissed as? UIViewController & PopupPresentationSupport, let to = from.presentingViewController else { return nil }

			return PopupPresentationAnimationController(dismissalFrom: from,
														to: to,
														overlaysToView: false,
														overlaySupport: PaymentOptionsViewController.tap_findInHierarchy())
		}
		
        fileprivate func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            
            if
                
                let otpAnimator = animator as? PopupPresentationAnimationController,
                let otpController = otpAnimator.fromViewController as? OTPViewController,
                let interactionController = otpController.dismissalInteractionController, interactionController.isInteracting {
                
                otpAnimator.canFinishInteractiveTransitionDecisionHandler = { [weak otpController] (decision) in
                    
                    guard let controller = otpController else {
                        
                        decision(true)
                        return
                    }
                    
                    controller.canDismissInteractively(decision)

                }
                
                interactionController.delegate = otpAnimator
                return interactionController
            }
            else {
                
                return nil
            }
        }
    }
    
    private struct Constants {
        
        fileprivate static let dismissalArrowImage: UIImage = {
           
            guard let result = UIImage.tap_named("ic_close_otp", in: .goSellSDKResources) else {
                
                fatalError("Failed to load \"ic_close_otp\" icon from the resources bundle.")
            }
            
            return result
        }()
        
        fileprivate static let descriptionFont:     UIFont  = .helveticaNeueRegular(14.0)
        fileprivate static let countdownFont:       UIFont  = .helveticaNeueRegular(13.0)
        fileprivate static let resendFont:          UIFont  = .helveticaNeueMedium(13.0)
        
        fileprivate static let descriptionColor:    UIColor = .tap_hex("535353")
        fileprivate static let numberColor:         UIColor = .tap_hex("1584FC")
        
        fileprivate static let resendColor:             UIColor = .tap_hex("007AFF")
        fileprivate static let resendHighlightedColor:  UIColor = .tap_hex("0D61E7")
        
        fileprivate static let updateTimerTimeInterval: TimeInterval = 1.0
        fileprivate static let resendButtonTitleDateFormat = "mm:ss"
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var dismissalView: UIView?
    @IBOutlet weak var blurView: TapVisualEffectView!
    
    @IBOutlet weak var otpHolderView: UIView?{
        didSet
        {
            self.otpHolderView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.36).loadCompatibleDarkModeColor(forColorNamed: "OTPHolderColor")
        }
    }
    @IBOutlet private weak var dismissalArrowImageView: UIImageView? {
        
        didSet {
            
            self.dismissalArrowImageView?.image = Constants.dismissalArrowImage
        }
    }
    
    @IBOutlet private weak var otpInputView: OTPInputView? {
        
        didSet {
            
            self.otpInputView?.delegate = self
            self.updateConfirmationButtonState()
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel? {
        
        didSet {
            
            self.updateDescriptionLabelText()
        }
    }
    
    @IBOutlet private weak var resendButton: UIButton?
    @IBOutlet private weak var resendButtonLabel: UILabel?
    
    @IBOutlet private weak var confirmationButton: TapButton? {
        
        didSet {
            
            self.confirmationButton?.delegate = self
			self.confirmationButton?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == .confirmOTP })!
            self.updateConfirmationButtonState()
        }
    }
    
    @IBOutlet private weak var contentViewTopOffsetConstraint: NSLayoutConstraint?
    
    private static var storage: OTPViewController?
    
    private var alreadyStartedFirstAttempt: Bool = false
    
    private lazy var timerDataManager: OTPTimerDataManager = OTPTimerDataManager()
    
    private lazy var countdownDateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale = LocalizationManager.shared.selectedLocale
        formatter.dateFormat = Constants.resendButtonTitleDateFormat
        
        return formatter
    }()
    
    private var phoneNumber: String = .tap_empty {
        
        didSet {
            
            self.updateDescriptionLabelText()
        }
    }
    
    private weak var delegate: OTPViewControllerDelegate?
    
    private var transitioning: Transitioning? = Transitioning()
    
    // MARK: Methods
    
    private static func createAndSetupController() -> OTPViewController {
        
        KnownStaticallyDestroyableTypes.add(OTPViewController.self)
        
        let controller = self.shared
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = controller.transitioning
        
        return controller
    }
    
    private func updateDescriptionLabelText() {
        
        guard let nonnullLabel = self.descriptionLabel, self.phoneNumber.tap_length > 0 else { return }
		
		let numberString = "\u{202A}\(self.phoneNumber)\u{202C}"
		
		let descriptionText = String(format: LocalizationManager.shared.localizedString(for: .otp_guide_text), numberString)
		
		let themeSettings = Theme.current.otpScreenStyle
		
		let descriptionAttributes = themeSettings.descriptionText.asStringAttributes
        
        let attributedDescriptionText = NSMutableAttributedString(string: descriptionText, attributes: descriptionAttributes)
		
		if let range = attributedDescriptionText.string.tap_nsRange(of: numberString) {
			
			let numberAttributes = themeSettings.descriptionNumber.asStringAttributes
			
			let attributedMaskedNumberText = NSAttributedString(string: numberString, attributes: numberAttributes)
			
			attributedDescriptionText.replaceCharacters(in: range, with: attributedMaskedNumberText)
		}
        
        nonnullLabel.attributedText = NSAttributedString(attributedString: attributedDescriptionText)
    }
    
    private func startFirstAttemptIfNotYetStarted() {
        
        guard !self.alreadyStartedFirstAttempt else { return }
        
        self.startAnotherAttempt()
        self.alreadyStartedFirstAttempt = true
    }
    
    private func updateConfirmationButtonState() {
        
        guard let inputView = self.otpInputView else { return }
        
        self.makeConfirmationButtonEnabled(inputView.isProvidedDataValid)
    }
    
    private func makeConfirmationButtonEnabled(_ enabled: Bool) {
        
        self.confirmationButton?.isEnabled = enabled
    }
    
    private func startAttempt() {
        
        self.timerDataManager.startTimer(force: false) { [weak self] (state) in
            
            self?.updateResendButtonTitle(with: state)
        }
    }
    
    private func updateResendButtonTitle(with state: OTPTimerState) {
		
		let themeSettings = Theme.current.otpScreenStyle
		
        switch state {
            
        case .ticking(let remainingSeconds):
            
            let remainingDate = Date(timeIntervalSince1970: remainingSeconds)
            let title = self.countdownDateFormatter.string(from: remainingDate)
            
            self.resendButtonLabel?.text = title
			self.resendButtonLabel?.setTextStyle(themeSettings.timer)
			
            self.resendButtonLabel?.alpha = 1.0
            self.resendButton?.isEnabled = false
            
        case .notTicking:
			
			self.resendButtonLabel?.setLocalizedText(.btn_resend_title)
			self.resendButtonLabel?.setTextStyle(themeSettings.resend)
			
            self.resendButtonLabel?.alpha = 1.0
            self.resendButton?.isEnabled = true
            
        case .attemptsFinished:
			
			self.resendButtonLabel?.setLocalizedText(.btn_resend_title)
			self.resendButtonLabel?.setTextStyle(themeSettings.resend)
			
            self.resendButtonLabel?.alpha = 0.5
            self.resendButton?.isEnabled = false
        }
    }
    
    private func startAnotherAttempt() {
        
        self.otpInputView?.startEditing()
        self.startAttempt()
    }
    
    private func setResendLabelHighlighted(_ highlighted: Bool) {
        
        UIView.animate(withDuration: 0.1) {
            
            self.resendButtonLabel?.textColor = highlighted ? Constants.resendHighlightedColor : Constants.resendColor
        }
    }
    
    @IBAction private func resendButtonHighlighted(_ sender: Any) {
        
        self.setResendLabelHighlighted(true)
    }
    
    @IBAction private func resendButtonLostHighlight(_ sender: Any) {
        
        self.setResendLabelHighlighted(false)
    }
    
    @IBAction private func resendButtonTouchUpInside(_ sender: Any) {
        
        self.resendOTPCode()
    }
    
    @IBAction private func dismissalViewTapDetected(_ recognizer: UITapGestureRecognizer) {
        
        guard let recognizerView = recognizer.view, recognizerView.bounds.contains(recognizer.location(in: recognizerView)), recognizer.state == .ended else {
            
            return
        }
        
        self.showCancelAttemptAlert { (shouldCancel) in
            
            if shouldCancel {
                
                self.delegate?.otpViewControllerDidCancel(self)
                self.hide(animated: true)
            }
        }
    }
    
    private func resendOTPCode() {
        
        self.delegate?.otpViewControllerResendButtonTouchUpInside(self)
    }
    
    private func confirmOTPCode() {
        
        guard let code = self.otpInputView?.otp else { return }
        
        self.delegate?.otpViewController(self, didEnter: code)
    }
    
    private func canDismissInteractively(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        self.showCancelAttemptAlert { [weak self] (shouldCancel) in
            
            guard let strongSelf = self else {
                
                decision(shouldCancel)
                return
            }
            
            if shouldCancel {
                
                strongSelf.delegate?.otpViewControllerDidCancel(strongSelf)
            }
            
            decision(shouldCancel)
        }
    }
    
    private func showCancelAttemptAlert(_ decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = TapAlertController(titleKey: .alert_cancel_payment_title, messageKey: .alert_cancel_payment_message, preferredStyle: .alert)
		
        let cancelCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_btn_no_title, style: .cancel) { [weak alert] (action) in
			
			guard let nonnullAlert = alert else {
				
				decision(false)
				return
			}
			
			nonnullAlert.hide {
				
				decision(false)
			}
        }
        let confirmCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_btn_confirm_title, style: .destructive) { [weak alert] (action) in
			
			guard let nonnullAlert = alert else {
				
				decision(true)
				return
			}
			
			nonnullAlert.hide {
				
				decision(true)
			}
        }
        
        alert.addAction(cancelCancelAction)
        alert.addAction(confirmCancelAction)
        
        alert.show()
    }
}

// MARK: - InstantiatableFromStoryboard
extension OTPViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPayment
    }
}

// MARK: - DelayedDestroyable
extension OTPViewController: DelayedDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        if let nonnullStorage = self.storage {
            
            nonnullStorage.transitioning?.shouldUseDefaultOTPAnimation = false
            nonnullStorage.hide(animated: true) {
                
                self.storage = nil
                KnownStaticallyDestroyableTypes.delayedDestroyableInstanceDestroyed()
                completion?()
            }
        }
        else {
            
            completion?()
        }
    }
}

// MARK: - Singleton
extension OTPViewController: Singleton {
    
    internal static var shared: OTPViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = OTPViewController.instantiate()
        instance.transitioning?.shouldUseDefaultOTPAnimation = true
        
        self.storage = instance
        
        return instance
    }
}

// MARK: - TapButton.Delegate
extension OTPViewController: TapButton.Delegate {
	
    internal var canBeHighlighted: Bool {
        
        return true
    }
    
    internal func buttonTouchUpInside() {
        
        self.confirmOTPCode()
    }
    
    internal func securityButtonTouchUpInside() {
        
        self.buttonTouchUpInside()
    }
	
	internal func disabledButtonTouchUpInside() {}
}

// MARK: - OTPInputViewDelegate
extension OTPViewController: OTPInputViewDelegate {
    
    internal func otpInputView(_ otpInputView: OTPInputView, inputStateChanged valid: Bool, wholeOTPAtOnce: Bool) {
        
        self.makeConfirmationButtonEnabled(valid)
        
        if valid && wholeOTPAtOnce {
            
            self.confirmOTPCode()
        }
    }
}

// MARK: - PopupPresentationSupport
extension OTPViewController: PopupPresentationSupport {
    
    internal var presentationAnimationAnimatingConstraint: NSLayoutConstraint? {
        
        return self.contentViewTopOffsetConstraint
    }
    
    internal var viewToLayout: UIView {
        
        return self.view
    }
}

// MARK: - LoadingViewSupport
extension OTPViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.view
	}
}
