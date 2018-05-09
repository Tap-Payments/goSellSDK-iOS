//
//  TapNavigationView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGSize
import class TapNibView.TapNibView
import class UIKit.UIButton.UIButton
import class UIKit.UIImage.UIImage
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen

/// Tap Navigation View
internal class TapNavigationView: TapNibView {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate
    internal weak var delegate: TapNavigationViewDelegate?
    
    /// Icon image.
    internal var iconImage: UIImage? {
        
        get {
            
            return self.iconImageView?.image
        }
        set {
            
            self.iconImageView?.image = newValue
        }
    }
    
    /// Title.
    internal var title: String? {
        
        get {
            
            return self.titleLabel?.text
        }
        set {
            
            self.titleLabel?.text = newValue
        }
    }
    
    internal override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    internal override var intrinsicContentSize: CGSize {
        
        let screen = self.window?.screen ?? UIScreen.main
        return CGSize(width: screen.bounds.width, height: Constants.height)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let height: CGFloat = 66.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var backButton: UIButton?
    
    @IBOutlet private weak var iconImageView: UIImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    // MARK: Methods
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        
        self.delegate?.navigationViewBackButtonClicked(self)
    }
}
