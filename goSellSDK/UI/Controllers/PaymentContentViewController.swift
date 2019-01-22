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
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

/// Payment Content View Controller.
internal class PaymentContentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[PaymentProcess.shared.dataManager.appearance].uiStatusBarStyle
	}
	
	/// Layout listener.
	internal weak var layoutListener: ViewControllerLayoutListener?
	
	internal override var preferredContentSize: CGSize {
		
		get {
			
			let headerSize = self.headerViewController?.preferredContentSize ?? .zero
			let paymentOptionsSize = self.paymentOptionsViewController?.preferredContentSize ?? .zero
			let payButtonContainerSize = self.payButtonContainerView?.bounds.size ?? .zero
			
			let width = ceil(max(headerSize.width, paymentOptionsSize.width, payButtonContainerSize.width))
			let height = ceil(headerSize.height + paymentOptionsSize.height + payButtonContainerSize.height)
			
			return CGSize(width: width, height: height)
		}
		set {
			
			super.preferredContentSize = newValue
		}
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
        
        if let merchantHeaderController = segue.destination as? MerchantInformationHeaderViewController {
			
			self.headerViewController = merchantHeaderController
            merchantHeaderController.delegate = self
        }
        else if let paymentOptionsController = segue.destination as? PaymentOptionsViewController {
            
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
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsContainerView: UIView?
	@IBOutlet private weak var loadingContainerView: UIView?
	
	@IBOutlet private weak var payButtonContainerView: UIView?
    @IBOutlet private weak var payButtonUI: TapButton? {
        
        didSet {
            
            if let nonnullPayButton = self.payButtonUI {
				
				PaymentProcess.shared.buttonHandler.setButton(nonnullPayButton)
            }
        }
    }
	
	private weak var headerViewController: BaseViewController?
    private weak var paymentOptionsViewController: BaseViewController?
}

// MARK: - MerchantInformationHeaderViewControllerDelegate
extension PaymentContentViewController: MerchantInformationHeaderViewControllerDelegate {
    
    internal func merchantInformationHeaderViewControllerCloseButtonClicked(_ controller: MerchantInformationHeaderViewController) {
        
        PaymentProcess.shared.closePayment(with: .cancelled, fadeAnimation: false, force: false, completion: nil)
    }
}

// MARK: - NavigationContentViewController
extension PaymentContentViewController: NavigationContentViewController {
	
	internal var contentTopOffset: CGFloat {
		
		if let frame = self.paymentOptionsContainerView?.frame {
			
			return self.view.convert(frame, to: self.view.window).origin.y
		}
		else {
			
			return 0.0
		}
	}
}

// MARK: - LoadingViewSupport
extension PaymentContentViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.loadingContainerView ?? self.view
	}
}
