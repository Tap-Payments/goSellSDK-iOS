//
//  LoadingImageView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapGLKit.TapActivityIndicatorView
import class TapNibView.TapNibView

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
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var imageView: UIImageView?
    
    @IBOutlet private weak var activityIndicator: TapActivityIndicatorView?
    
    // MARK: Methods
    
    private func updateUIBasedOnState() {
        
        switch self.loadingState {
            
        case .notLoaded:
            
            self.activityIndicator?.stopAnimating()
            
        case .loading:
            
            self.activityIndicator?.startAnimating()
            
        case .loaded(let image):
            
            self.activityIndicator?.stopAnimating()
            self.imageView?.image = image
        }
    }
}
