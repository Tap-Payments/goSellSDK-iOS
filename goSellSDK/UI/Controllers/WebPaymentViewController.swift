//
//  WebPaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    TapNetworkManager.TapImageLoader
import class    UIKit.UIImage.UIImage
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIView.UIView
import class    WebKit.WKNavigation.WKNavigation
import class    WebKit.WKNavigationAction.WKNavigationAction
import enum     WebKit.WKNavigationDelegate.WKNavigationActionPolicy
import protocol WebKit.WKNavigationDelegate.WKNavigationDelegate
import class    WebKit.WKWebView.WKWebView
import class    WebKit.WKWebViewConfiguration.WKWebViewConfiguration

internal class WebPaymentViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setup(with paymentOption: PaymentOption, url: URL?, binInformation: BINResponse?) {
        
        self.paymentOption  = paymentOption
        self.url            = url
        self.binInformation = binInformation
        
        self.loadIcon()
        self.updateHeaderTitle()
    }
    
    internal override func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
        
        super.headerNavigationViewLoaded(headerView)
        
        self.updateHeaderIcon()
        self.updateHeaderTitle()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var webViewContainer: UIView? {
        
        didSet {
            
            if self.webViewContainer != nil {
                
                self.addWebViewOnScreen()
                self.loadURLIfNotYetLoaded()
            }
        }
    }
    
    @IBOutlet private weak var progressBar: WebViewProgressBar? {
        
        didSet {
            
            self.progressBar?.setup(with: self.webView)
        }
    }
    
    private var webView: WKWebView = {
        
        let configuration = WKWebViewConfiguration()
        configuration.suppressesIncrementalRendering = true
        
        let result = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        
        if #available(iOS 9.0, *) {
            
            result.allowsLinkPreview = false
        }
        
        return result
    }()
    
    private var url: URL? {
        
        didSet {
            
            
            self.loadURLIfNotYetLoaded()
        }
    }
    
    private var paymentOption: PaymentOption?
    private var binInformation: BINResponse?
    
    private var iconImage: UIImage? {
        
        didSet {
            
            self.updateHeaderIcon()
        }
    }
    
    // MARK: Methods
    
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
    
    private func addWebViewOnScreen() {
        
        self.webView.navigationDelegate = self

        self.webViewContainer?.addSubviewWithConstraints(self.webView)
    }
    
    private func loadURLIfNotYetLoaded() {
        
        guard let nonnullURL = self.url, self.webView.superview != nil else { return }
        
        let urlRequest = URLRequest(url: nonnullURL)
        self.webView.load(urlRequest)
    }
}

// MARK: - WKNavigationDelegate
extension WebPaymentViewController: WKNavigationDelegate {
    
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            
            decisionHandler(.cancel)
            return
        }
        
        let decision = PaymentDataManager.shared.decision(forWebPayment: url)

        decisionHandler(decision.shouldLoad ? .allow : .cancel)
        
        if decision.redirectionFinished {
            
            PaymentDataManager.shared.webPaymentProcessFinished()
        }
        
        if decision.shouldCloseWebPaymentScreen {
            
            self.pop()
        }
    }
    
    internal func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        
    }
}
