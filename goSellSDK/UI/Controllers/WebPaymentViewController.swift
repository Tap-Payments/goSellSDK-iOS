//
//  WebPaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import struct   TapAdditionsKit.TypeAlias
import class    TapNetworkManager.TapImageLoader
import class    UIKit.UIAlertController.UIAlertAction
import class    UIKit.UIAlertController.UIAlertController
import class    UIKit.UIImage.UIImage
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal class WebPaymentViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
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
                PaymentDataManager.shared.paymentCancelled()
                contentViewController.cancelLoading()
            }
            
            decision(willCancelPayment)
        }
        
        if contentViewController.isLoading || LoadingViewController.findInHierarchy() != nil {
         
            self.showCancelAttemptUndefinedStatusAlert(localDecision)
        }
        else {
            
            self.showCancelAttemptAlert(localDecision)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
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
        
        if let bankName = self.binInformation?.bank, bankName.length > 0 {
            
            self.headerNavigationView?.title = bankName
        }
        else {
            
            self.headerNavigationView?.title = self.paymentOption?.title
        }
    }
    
    private func showCancelAttemptAlert(_ decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = UIAlertController(titleKey: .alert_cancel_payment_title, messageKey: .alert_cancel_payment_message, preferredStyle: .alert)
		
        let cancelCancelAction = UIAlertAction(titleKey: .alert_cancel_payment_btn_no_title, style: .cancel) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
            }
            
            decision(false)
        }
		
        let confirmCancelAction = UIAlertAction(titleKey: .alert_cancel_payment_btn_confirm_title, style: .destructive) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
            }
            
            decision(true)
        }
        
        alert.addAction(cancelCancelAction)
        alert.addAction(confirmCancelAction)
        
        DispatchQueue.main.async {
            
            alert.showOnSeparateWindow(true, below: .statusBar, completion: nil)
        }
    }
    
    private func showCancelAttemptUndefinedStatusAlert(_ decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = UIAlertController(titleKey: 		.alert_cancel_payment_status_undefined_title,
									  messageKey: 		.alert_cancel_payment_status_undefined_message,
									  preferredStyle:	.alert)
		
        let cancelCancelAction = UIAlertAction(titleKey: .alert_cancel_payment_status_undefined_btn_no_title, style: .cancel) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
            }
            
            decision(false)
        }
        let confirmCancelAction = UIAlertAction(titleKey: .alert_cancel_payment_status_undefined_btn_confirm_title, style: .destructive) { [weak alert] (action) in
            
            DispatchQueue.main.async {
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
            }
            
            decision(true)
        }
        
        alert.addAction(cancelCancelAction)
        alert.addAction(confirmCancelAction)
        
        DispatchQueue.main.async {
            
            alert.showOnSeparateWindow(true, below: .statusBar, completion: nil)
        }
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
        
        return LoadingViewController.findInHierarchy() == nil
    }
    
    internal func canFinishInteractiveTransition(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        self.requestToPop(decision)
    }
}
