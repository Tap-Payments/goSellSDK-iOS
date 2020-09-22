//
//  WebViewProgressBar.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import class    TapNibViewV2.TapNibView
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIColor.UIColor
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIView.UIView
import class    WebKit.WKWebView.WKWebView

@IBDesignable internal final class WebViewProgressBar: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    @IBInspectable internal var showsFullProgress: Bool = true {
        
        didSet {
            
            self.updateProgress()
        }
    }
    
    @IBInspectable internal var progressColor: UIColor = .tap_hex("535353") {
        
        didSet {
            
            self.updateProgressBarColor()
        }
    }
    
    internal var progress: CGFloat {
        
        return CGFloat(self.webView?.estimatedProgress ?? 0.0)
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal override var intrinsicContentSize: CGSize {
        
        let screen = self.window?.screen ?? UIScreen.main
        return CGSize(width: screen.bounds.width, height: Constants.height)
    }
    
    // MARK: Methods
    
    internal func setup(with webView: WKWebView) {
        
        self.webView = webView
    }
	
	internal func unbindFromWebView() {
		
		self.webView = nil
	}
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let nonnullKeyPath = keyPath, Constants.observableKeyPaths.contains(nonnullKeyPath), (object as? WKWebView) === self.webView else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        self.updateProgress(animated: true)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let height: CGFloat = 3.0
        fileprivate static let progressChangeAnimationDuration: TimeInterval = 0.25
        
        fileprivate static let observableKeyPaths: [String] = [
            
            Constants.estimatedProgressKeyPath,
            Constants.isLoadingKeyPath
        ]
        
        private static let estimatedProgressKeyPath = #keyPath(WKWebView.estimatedProgress)
        private static let isLoadingKeyPath         = #keyPath(WKWebView.isLoading)
        
        
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var contentView: UIView?
    
    @IBOutlet private weak var progressBarView: UIView? {
        
        didSet {
            
            self.updateProgressBarColor()
        }
    }
    
    @IBOutlet private weak var progressConstraint: NSLayoutConstraint? {
        
        didSet {
            
            self.updateProgress()
        }
    }
    
    private weak var webView: WKWebView? {
		
        didSet {
			
			self.updateObservers(oldValue, newWebView: self.webView)
            self.updateProgress()
        }
    }
    
    // MARK: Methods
	
	private func updateObservers(_ oldWebview: WKWebView?, newWebView: WKWebView?) {
		
		if let nonnullOldWebView = oldWebview {
			
			self.removeObservers(from: nonnullOldWebView)
		}
		
		if let nonnullNewWebView = newWebView {
			
			self.addObservers(on: nonnullNewWebView)
		}
	}
	
	private func addObservers(on webview: WKWebView) {
		
        Constants.observableKeyPaths.forEach {
            
            webview.addObserver(self, forKeyPath: $0, options: .new, context: nil)
        }
    }
    
	private func removeObservers(from webview: WKWebView) {
		
        Constants.observableKeyPaths.forEach {
            
            webview.removeObserver(self, forKeyPath: $0)
        }
    }
    
    private func updateProgress(animated: Bool = false) {
        
        DispatchQueue.main.async {
            
            let aProgress = self.progress
            
            let progressWidth = aProgress * self.bounds.width
            let alpha: CGFloat = (self.showsFullProgress || aProgress != 1.0) ? 1.0 : 0.0
            
            let animations: TypeAlias.ArgumentlessClosure = { [unowned self] in
                
                self.progressConstraint?.constant = progressWidth
                self.contentView?.alpha = alpha
                self.tap_layout()
            }
            
            let duration = animated ? Constants.progressChangeAnimationDuration : 0.0
            UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: animations, completion: nil)
        }
    }
    
    private func updateProgressBarColor() {
        
        self.progressBarView?.backgroundColor = self.progressColor
    }
}
