//
//  WebPaymentContentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class    UIKit.UIView.UIView
import class    WebKit.WKNavigation.WKNavigation
import class    WebKit.WKNavigationAction.WKNavigationAction
import enum     WebKit.WKNavigationDelegate.WKNavigationActionPolicy
import protocol WebKit.WKNavigationDelegate.WKNavigationDelegate
import class    WebKit.WKWebView.WKWebView
import class    WebKit.WKWebViewConfiguration.WKWebViewConfiguration

internal final class WebPaymentContentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: WebPaymentContentViewControllerDelegate?
    
    internal var isLoading: Bool {
        
        return self.webView.isLoading
    }
    
    // MARK: Methods
    
    internal func setup(with url: URL) {
        
        self.url = url
    }
    
    internal func cancelLoading() {
        
        self.webView.stopLoading()
    }
    
    deinit {
        
        self.webView.scrollView.delegate = nil
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
    
    private var lastAttemptedURL: URL? = nil
    
    // MARK: Methods
    
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
extension WebPaymentContentViewController: WKNavigationDelegate {
    
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            
            decisionHandler(.cancel)
            return
        }
        
        let decision = PaymentDataManager.shared.decision(forWebPayment: url)
        if decision.shouldLoad {
            
            self.lastAttemptedURL = url
        }
        
        decisionHandler(decision.shouldLoad ? .allow : .cancel)
        
        if decision.redirectionFinished, let chargeOrAuthorizeID = decision.tapID {
            
            PaymentDataManager.shared.webPaymentProcessFinished(chargeOrAuthorizeID)
        }
        
        if decision.shouldCloseWebPaymentScreen {
            
            self.delegate?.webPaymentContentViewControllerRequestedDismissal(self)
        }
    }
    
    internal func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let tapError = TapSDKKnownError(type: .network, error: error, response: nil)
        
        var retryAction: TypeAlias.ArgumentlessClosure? = nil
        
        if self.lastAttemptedURL != nil {
            
            retryAction = {
                
                if let lastURL = self.lastAttemptedURL {
                    
                    let request = URLRequest(url: lastURL)
                    webView.load(request)
                }
            }
        }
        
        let alertDismissHandler: TypeAlias.ArgumentlessClosure = {
            
            self.delegate?.webPaymentContentViewControllerRequestedDismissal(self)
        }
        
        ErrorDataManager.handle(tapError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissHandler)
    }
}
