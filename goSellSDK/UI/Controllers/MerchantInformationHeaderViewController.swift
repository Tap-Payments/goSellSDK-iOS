//
//  MerchantInformationHeaderViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGSize
import func     TapAdditionsKit.clamp
import class    TapNetworkManager.TapImageLoader
import class    UIKit.UIButton.UIButton
import class    UIKit.UIColor.UIColor
import class    UIKit.UILabel.UILabel
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

/// Merchant information header view controller.
internal class MerchantInformationHeaderViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate
    internal weak var delegate: MerchantInformationHeaderViewControllerDelegate?
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
		
        self.updateMerchantLabelTitle()
        self.loadMerchantLogo()
        self.setupShadow()
    }
    
    internal func updateBackgroundOpacityBasedOnScrollContentOverlapping(_ overlapping: CGFloat) {
        
        let opacity = clamp(value: 2.0 * overlapping / self.view.bounds.height, low: 0.0, high: 1.0)
        
        self.backgroundOpacity = opacity
        self.view.layer.shadowOpacity = Float(opacity)
    }
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		self.titleLabel?.setTextStyle(Theme.current.merchantHeaderStyle.titleStyle)
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		let merchantHeaderStyle = Theme.current.merchantHeaderStyle
		
		self.titleLabel?.setTextStyle(merchantHeaderStyle.titleStyle)
		
		self.backgroundView?.backgroundColor	= merchantHeaderStyle.backgroundColor
		self.iconView?.placeholderImage 		= merchantHeaderStyle.placeholderLogo
		self.iconView?.loaderColor 				= merchantHeaderStyle.logoLoaderColor
		
		self.closeButton?.setImage(Theme.current.commonStyle.icons.closeImage, for: .normal)
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
    
    private func updateMerchantLabelTitle() {
        
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
    
    private func setupShadow() {
        
        self.view.layer.shadowOpacity	= 0.0
        self.view.layer.shadowOffset 	= CGSize(width: 0.0, height: 1.0)
        self.view.layer.shadowRadius 	= 1.0
        self.view.layer.shadowColor 	= UIColor.lightGray.cgColor
    }
}
