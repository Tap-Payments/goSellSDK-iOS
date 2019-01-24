//
//  WebPaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGPoint
import struct	CoreGraphics.CGGeometry.CGSize
import struct   TapAdditionsKit.TypeAlias
import class    TapNetworkManager.TapImageLoader
import enum		UIKit.UIApplication.UIStatusBarStyle
import class    UIKit.UIImage.UIImage
import class    UIKit.UIScreen.UIScreen
import class	UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class WebPaymentViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
	// MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[.fullscreen].uiStatusBarStyle
	}
	
	internal override var preferredContentSize: CGSize {
		
		get {
		
			return UIScreen.main.bounds.size
		}
		set {
			
			super.preferredContentSize = UIScreen.main.bounds.size
		}
	}
	
	internal override var contentTopOffset: CGFloat {
		
		if let contentView = self.contentContainerView {
			
			return contentView.frame.origin.y
		}
		else {
			
			return self.view.convert(self.view.bounds, to: self.view.window).origin.y
		}
	}
	
    // MARK: Methods
    
    internal func setup(with paymentOption: PaymentOption, url: URL?, binInformation: BINResponse?) {
        
        self.paymentOption  = paymentOption
        self.binInformation = binInformation
        self.initialURL     = url
        
        self.loadIcon()
        self.updateHeaderTitle()
    }
    
    internal override func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
        
        super.headerNavigationViewLoaded(headerView)
        
        self.updateHeaderIcon()
        self.updateHeaderTitle()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let webPaymentContentController = segue.destination as? WebPaymentContentViewController {
            
            self.contentController = webPaymentContentController
        }
    }
    
    internal override func requestToPop(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        guard let contentViewController = self.contentController else {
            
            decision(true)
            return
        }
        
        let localDecision: TypeAlias.BooleanClosure =  { (willCancelPayment) in
            
            if willCancelPayment {
                
                APIClient.shared.cancelAllRequests()
                Process.shared.dataManagerInterface.paymentCancelled()
                contentViewController.cancelLoading()
            }
            
            decision(willCancelPayment)
        }
        
        if contentViewController.isLoading || LoadingViewController.tap_findInHierarchy() != nil {
         
            self.showCancelAttemptUndefinedStatusAlert(localDecision)
        }
        else {
            
            self.showCancelAttemptAlert(localDecision)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
	
	@IBOutlet private weak var contentContainerView: UIView?
    
    private var paymentOption: PaymentOption?
    private var binInformation: BINResponse?
    private var initialURL: URL? {
        
        didSet {
            
            self.passURLToContentController()
        }
    }
    
    private var iconImage: UIImage? {
        
        didSet {
            
            self.updateHeaderIcon()
        }
    }
    
    private weak var contentController: WebPaymentContentViewController? {
        
        didSet {
            
            self.contentController?.delegate = self
            self.passURLToContentController()
        }
    }
    
    // MARK: Methods
    
    private func passURLToContentController() {
        
        guard let controller = self.contentController, let url = self.initialURL else { return }
        
        controller.setup(with: url)
    }
    
    private func loadIcon() {
        
        guard let nonnullImageURL = self.binInformation?.bankLogoURL ?? self.paymentOption?.imageURL else { return }
        
        TapImageLoader.shared.downloadImage(from: nonnullImageURL) { (image, error) in
            
            self.iconImage = image
        }
    }
    
    private func updateHeaderIcon() {
        
        self.headerNavigationView?.iconImage = self.iconImage
    }
    
    private func updateHeaderTitle() {
        
        if let bankName = self.binInformation?.bank, bankName.tap_length > 0 {
            
            self.headerNavigationView?.title = bankName
        }
        else {
            
            self.headerNavigationView?.title = self.paymentOption?.title
        }
    }
    
    private func showCancelAttemptAlert(_ decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = TapAlertController(titleKey: .alert_cancel_payment_title, messageKey: .alert_cancel_payment_message, preferredStyle: .alert)
		
        let cancelCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_btn_no_title, style: .cancel) { [weak alert] (action) in
            
            alert?.hide()
            decision(false)
        }
		
        let confirmCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_btn_confirm_title, style: .destructive) { [weak alert] (action) in
            
            alert?.hide()
            decision(true)
        }
        
        alert.addAction(cancelCancelAction)
        alert.addAction(confirmCancelAction)
        
        alert.show()
    }
    
    private func showCancelAttemptUndefinedStatusAlert(_ decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = TapAlertController(titleKey: 		.alert_cancel_payment_status_undefined_title,
									   messageKey: 		.alert_cancel_payment_status_undefined_message,
									   preferredStyle:	.alert)
		
		let cancelCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_status_undefined_btn_no_title, style: .cancel) { [weak alert] (action) in
			
            alert?.hide()
            decision(false)
        }
        let confirmCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_status_undefined_btn_confirm_title, style: .destructive) { [weak alert] (action) in
            
            alert?.hide()
            decision(true)
        }
        
        alert.addAction(cancelCancelAction)
        alert.addAction(confirmCancelAction)
        
        alert.show()
    }
}

// MARK: - WebPaymentContentViewControllerDelegate
extension WebPaymentViewController: WebPaymentContentViewControllerDelegate {
    
    internal func webPaymentContentViewControllerRequestedDismissal(_ controller: WebPaymentContentViewController) {
        
        self.pop()
    }
}

// MARK: - InteractiveTransitionControllerDelegate
extension WebPaymentViewController: InteractiveTransitionControllerDelegate {
    
    internal var canStartInteractiveTransition: Bool {
        
        return LoadingViewController.tap_findInHierarchy() == nil
    }
    
    internal func canFinishInteractiveTransition(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        self.requestToPop(decision)
    }
}

// MARK: - InstantiatableFromStoryboard
extension WebPaymentViewController: InstantiatableFromStoryboard {
	
	internal static var hostingStoryboard: UIStoryboard {
		
		return .goSellSDKPayment
	}
}

// MARK: - LoadingViewSupport
extension WebPaymentViewController: LoadingViewSupport {
	
	internal var loadingViewContainer: UIView {
		
		return self.contentContainerView ?? self.view
	}
}
