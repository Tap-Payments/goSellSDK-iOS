//
//  WebPaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    TapNetworkManager.TapImageLoader
import class    UIKit.UIImage.UIImage
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView

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
}

// MARK: - WebPaymentContentViewControllerDelegate
extension WebPaymentViewController: WebPaymentContentViewControllerDelegate {
    
    internal func webPaymentContentViewControllerRequestedDismissal(_ controller: WebPaymentContentViewController) {
        
        self.pop()
    }
}
