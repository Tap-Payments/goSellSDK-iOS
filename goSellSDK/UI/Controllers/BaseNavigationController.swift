//
//  BaseNavigationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum UIKit.UIApplication.UIInterfaceOrientation
import struct UIKit.UIApplication.UIInterfaceOrientationMask
import class UIKit.UINavigationController.UINavigationController

internal class BaseNavigationController: UINavigationController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override var shouldAutorotate: Bool {
        
        return false
    }
    
    internal override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return .portrait
    }
    
    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
}
