//
//  MerchantInformationHeaderViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGSize
import func TapAdditionsKit.clamp
import class TapNetworkManager.TapImageLoader
import class UIKit.UIButton.UIButton
import class UIKit.UIColor.UIColor
import class UIKit.UILabel.UILabel
import class UIKit.UIView.UIView
import class UIKit.UIViewController.UIViewController

/// Merchant information header view controller.
internal class MerchantInformationHeaderViewController: UIViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate
    internal weak var delegate: MerchantInformationHeaderViewControllerDelegate?
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadTheme()
        self.updateMerchantTitleLabel()
        self.loadMerchantLogo()
        self.setupShadow()
    }
    
    internal func updateBackgroundOpacityBasedOnScrollContentOverlapping(_ overlapping: CGFloat) {
        
        let opacity = clamp(value: 2.0 * overlapping / self.view.bounds.height, low: 0.0, high: 1.0)
//        let shadowOpacity = Float(1.0 - opacity)
        
        self.backgroundOpacity = opacity
        self.view.layer.shadowOpacity = Float(opacity)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var iconView: LoadingImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var closeButton: UIButton?
    
    @IBOutlet private weak var backgroundView: UIView?
    
    private var merchant: Merchant? {
        
        return SettingsDataManager.shared.settings?.merchant
    }
    
    private var backgroundOpacity: CGFloat {
        
        get {
            
            return self.backgroundView?.alpha ?? 0.0
        }
        set {
            
            self.backgroundView?.alpha = newValue
        }
    }
    
    // MARK: Methods
    
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.merchantInformationHeaderViewControllerCloseButtonClicked(self)
    }
    
    private func updateMerchantTitleLabel() {
        
        self.titleLabel?.text = self.merchant?.name
    }
    
    private func loadMerchantLogo() {
        
        guard let url = self.merchant?.logoURL else {
            
            self.iconView?.loadingState = .notLoaded
            return
        }
        
        self.iconView?.loadingState = .loading
        
        TapImageLoader.shared.downloadImage(from: url) { [weak self] (image, error) in
            
            guard let strongSelf = self else { return }
            
            if let nonnullImage = image {
                
                strongSelf.iconView?.loadingState = .loaded(image: nonnullImage)
            }
            else {
                
                strongSelf.iconView?.loadingState = .notLoaded
            }
        }
    }
    
    private func loadTheme() {
        
        let headerSettings = Theme.current.settings.headerSettings
        
        self.backgroundView?.backgroundColor = headerSettings.backgroundColor
        self.iconView?.placeholderImage = headerSettings.placeholderLogo
        self.iconView?.loaderColor = headerSettings.logoLoaderColor
        self.titleLabel?.textColor = headerSettings.textColor
        self.closeButton?.setImage(headerSettings.closeImage, for: .normal)
    }
    
    private func setupShadow() {
        
        self.view.layer.shadowOpacity = 0.0
        self.view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.view.layer.shadowRadius = 1.0
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
