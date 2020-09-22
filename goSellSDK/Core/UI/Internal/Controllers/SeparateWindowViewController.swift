//
//  SeparateWindowViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    TapAdditionsKitV2.SeparateWindowRootViewController
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView

internal class SeparateWindowViewController: BaseViewController {
    
    // MARK: - Internal -
	// MARK: Properties
	
	internal private(set) var topOffset: CGFloat = 0.0 {
		
		didSet {
			
			self.topOffsetMaskConstraint?.constant = self.topOffset
		}
	}
	
    // MARK: Methods
    
    internal func showExternally(animated: Bool = true, userInteractionEnabled: Bool = true, topOffset: CGFloat = 0.0, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.topOffset = topOffset
        
        let showClosure: TypeAlias.ArgumentlessClosure = {
			
            self.tap_showOnSeparateWindow(withUserInteractionEnabled: userInteractionEnabled, windowClass: MaskedWindow.self, below: .tap_statusBar) { [unowned self] (rootController) in
                
                (rootController.view.window as? MaskedWindow)?.contentProvider = self
                rootController.present(self, animated: animated, completion: completion)
            }
        }
        
        if let firstResponder = UIResponder.tap_current {
            
            firstResponder.tap_resignFirstResponder(showClosure)
        }
        else {
            
            showClosure()
        }
    }
    
    internal func hide(animated: Bool, async: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let closure: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            guard let strongSelf = self else {
                
                completion?()
                return
            }
            
            strongSelf.tap_hideKeyboard {
                
                strongSelf.tap_dismissFromSeparateWindow(animated, completion: completion)
            }
        }
        
        if async {
            
            DispatchQueue.main.async(execute: closure)
        }
        else {
            
            closure()
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var contentMaskView: UIView?
    @IBOutlet private weak var topOffsetMaskConstraint: NSLayoutConstraint? {
        
        didSet {
            
            self.topOffsetMaskConstraint?.constant = self.topOffset
        }
    }
}

// MARK: - MaskedWindowContentProvider
extension SeparateWindowViewController: MaskedWindowContentProvider {
    
    internal var mask: UIView {
        
        return self.contentMaskView ?? self.view
    }
}
