//
//  PaymentContentViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGRect
import struct	CoreGraphics.CGGeometry.CGSize
import struct   TapAdditionsKit.TypeAlias
import class    TapVisualEffectView.TapVisualEffectView
import enum		UIKit.UIApplication.UIStatusBarStyle
import class	UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

/// Payment Content View Controller.
internal class PaymentContentViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[Process.shared.appearance].uiStatusBarStyle
	}
	
	internal override var headerHasShadowInitially: Bool {
		
		return false
//		return Process.shared.appearance == .fullscreen
	}
	
	/// Layout listener.
	internal weak var layoutListener: ViewControllerLayoutListener?
	
	internal override var preferredContentSize: CGSize {
		
		get {
			
			let headerHeight = TapNavigationView.preferredHeight
			let paymentOptionsHeight = self.paymentOptionsViewController?.preferredContentSize.height ?? 0.0
			let payButtonContainerHeight = self.payButtonContainerView?.bounds.size.height ?? 0.0
			
			let width = (self.view.window?.screen ?? UIScreen.main).bounds.size.width
			let height = ceil(headerHeight + paymentOptionsHeight + payButtonContainerHeight)
			
			return CGSize(width: width, height: height)
		}
		set {
			
			super.preferredContentSize = newValue
		}
	}
	
	internal override var headerStyle: NavigationBarStyle {
		
		var style = Theme.current.merchantHeaderStyle
		if Process.shared.appearance == .windowed {
			
			style.backgroundColor = HexColor(tap_hex: "#ffffff")!
		}
		
		return style
	}
	
    // MARK: Methods
	
	internal override func viewDidLoad() {
		
		super.viewDidLoad()
		self.ignoresKeyboardEventsWhenWindowIsNotKey = true
	}
	
	internal override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		
		self.layoutListener?.viewControllerViewDidLayoutSubviews(self)
	}
	
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		super.prepare(for: segue, sender: sender)
		
		if let paymentOptionsController = segue.destination as? PaymentOptionsViewController {
			
			self.paymentOptionsViewController = paymentOptionsController
		}
	}
	
	internal override func performAdditionalAnimationsAfterKeyboardLayoutFinished() {
        
        self.paymentOptionsViewController?.performAdditionalAnimationsAfterKeyboardLayoutFinished()
    }
    
    internal func hide(usingFadeAnimation usesFadeAnimation: Bool = false, completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        DispatchQueue.main.async {
            
            self.tap_hideKeyboard {
                
                PaymentDismissalAnimationController.usesFadeAnimation = usesFadeAnimation
                
                let presentingController = self.presentingViewController as? PaymentViewController
                self.dismiss(animated: true) {

                    presentingController?.tap_dismissFromSeparateWindow(false, completion: completion)
                }
            }
        }
    }
	
	internal override func close() {
		
		Process.shared.closePayment(with: .cancelled, fadeAnimation: false, force: false, completion: nil)
	}
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsContainerView: UIView?
	@IBOutlet private weak var loadingContainerView: UIView?
	
	@IBOutlet private weak var payButtonContainerView: UIView?
    @IBOutlet private weak var payButtonUI: TapButton? {
        
        didSet {
            
            if let nonnullPayButton = self.payButtonUI {
				
				Process.shared.buttonHandlerInterface.setButton(nonnullPayButton)
            }
        }
    }
	
    private weak var paymentOptionsViewController: BaseViewController?
}

// MARK: - LoadingViewSupport
extension PaymentContentViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.loadingContainerView ?? self.view
	}
}

// MARK: - TapNavigationView.DataSource
extension PaymentContentViewController: TapNavigationView.DataSource {
	
	internal func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool {
		
		return (self.navigationController?.viewControllers.count ?? 0) > 1
	}
	
	internal func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image? {
		
		switch Process.shared.transactionMode {
		
		case .purchase, .authorizeCapture:
			
			if Process.shared.appearance == .windowed { return nil }
			
			if let placeholder = Theme.current.merchantHeaderStyle.iconStyle?.placeholder {
				
				return .ready(placeholder)
			}
			else {
				
				return nil
			}
			
		default:
			
			return nil
		}
	}
	
	internal func navigationViewIcon(for navigationView: TapNavigationView) -> Image? {
		
		switch Process.shared.transactionMode {
			
		case .purchase, .authorizeCapture:
			
			if Process.shared.appearance == .windowed { return nil }
			
			if let logoURL = SettingsDataManager.shared.settings?.merchant.logoURL {
				
				return .remote(logoURL)
			}
			
			return nil
			
		case .cardSaving:
			
			return nil
		}
	}
	
	internal func navigationViewTitle(for navigationView: TapNavigationView) -> String? {
		
		switch Process.shared.transactionMode {
			
		case .purchase, .authorizeCapture:
			
			if Process.shared.appearance == .fullscreen {
				
				return SettingsDataManager.shared.settings?.merchant.name
			}
			else {
				
				return LocalizationProvider.shared.localizedString(for: .payment_screen_title_payment)
			}
			
		case .cardSaving:
			
			return LocalizationProvider.shared.localizedString(for: .payment_screen_title_card_saving)
		}
	}
}
