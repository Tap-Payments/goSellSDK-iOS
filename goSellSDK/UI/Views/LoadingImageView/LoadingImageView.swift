//
//  LoadingImageView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapGLKit.TapActivityIndicatorView
import class TapNibView.TapNibView
import class UIKit.UIColor.UIColor
import class UIKit.UIImage.UIImage
import class UIKit.UIImageView.UIImageView

internal class LoadingImageView: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal var loadingState: LoadingImageViewState = .notLoaded {
        
        didSet {
            
            self.updateUIBasedOnState()
        }
    }
    
    internal var placeholderImage: UIImage?
    
    internal var loaderColor: UIColor? {
        
        didSet {
            
            if let nonnullColor = self.loaderColor {
                
                self.activityIndicator?.usesCustomColors = true
                self.activityIndicator?.outterCircleColor = nonnullColor
                self.activityIndicator?.innerCircleColor = nonnullColor
            }
            else {
                
                self.activityIndicator?.usesCustomColors = false
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var imageView: UIImageView?
    
    @IBOutlet private weak var activityIndicator: TapActivityIndicatorView? {
        
        didSet {
            
            self.activityIndicator?.animationDuration = Theme.current.commonStyle.loaderAnimationDuration
        }
    }
    
    // MARK: Methods
    
    private func updateUIBasedOnState() {
        
        switch self.loadingState {
            
        case .notLoaded:
            
            self.activityIndicator?.stopAnimating()
            self.imageView?.image = self.placeholderImage
            
        case .loading:
            
            self.activityIndicator?.startAnimating()
            self.imageView?.image = self.placeholderImage
            
        case .loaded(let image):
            
            self.activityIndicator?.stopAnimating()
            self.imageView?.image = image
        }
    }
}
