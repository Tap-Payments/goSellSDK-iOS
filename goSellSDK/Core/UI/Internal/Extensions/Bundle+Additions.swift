//
//  Bundle+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import TapAdditionsKitV2

internal extension Bundle {
    
    static let goSellSDKResources: Bundle = {
        
        #if SWIFT_PACKAGE
        // Swift Package Manager puts the storyboards, xibs, images, fonts and strings
        // in the package's own resource bundle.
        return Bundle.module
        #else
        guard let result = Bundle(for: PaymentContentViewController.self).tap_childBundle(named: Constants.goSellSDKResourcesBundleName) else {
            
            fatalError("There is no \(Constants.goSellSDKResourcesBundleName) bundle.")
        }
        
        return result
        #endif
    }()
    
    private struct Constants {
        
        fileprivate static let goSellSDKResourcesBundleName = "goSellSDKResources"
        
        //@available(*, unavailable) private init() { }
    }
}
