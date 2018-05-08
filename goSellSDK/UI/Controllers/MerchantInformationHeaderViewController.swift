//
//  MerchantInformationHeaderViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNetworkManager.TapImageLoader
import class UIKit.UIButton.UIButton
import class UIKit.UILabel.UILabel
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
        
        self.updateMerchantTitleLabel()
        self.loadMerchantLogo()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var iconView: LoadingImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    @IBOutlet private weak var closeButton: UIButton?
    
    private var merchant: Merchant? {
        
        return SettingsDataManager.shared.settings?.merchant
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
}
