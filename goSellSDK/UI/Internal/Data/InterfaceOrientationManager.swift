//
//  InterfaceOrientationManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UIApplication.UIApplication
import enum     UIKit.UIApplication.UIInterfaceOrientation
import struct   UIKit.UIApplication.UIInterfaceOrientationMask
import class    UIKit.UIDevice.UIDevice
import class    UIKit.UIViewController.UIViewController

/// Interface orientations manager.
internal final class InterfaceOrientationManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func viewControllerShouldAutorotate(_ controller: UIViewController) -> Bool {
        
        return UIDevice.current.tap_isIPad
    }
    
    internal func supportedInterfaceOrientations(for controller: UIViewController) -> UIInterfaceOrientationMask {
        
        return UIDevice.current.tap_isIPad ? .all : .portrait
    }
    
    internal func preferredInterfaceOrientationForPresentation(of controller: UIViewController) -> UIInterfaceOrientation {
        
        return UIDevice.current.tap_isIPad ? UIApplication.shared.statusBarOrientation : .portrait
    }
    
    // MARK: - Fileprivate -
    // MARK: Properties
    
    fileprivate static var storage: InterfaceOrientationManager?
    
    // MARK: - Private -
    // MARK: Methods
    
    private init() {
        
        KnownStaticallyDestroyableTypes.add(InterfaceOrientationManager.self)
    }
}

// MARK: - Singleton
extension InterfaceOrientationManager: Singleton {
    
    internal static var shared: InterfaceOrientationManager {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = InterfaceOrientationManager()
        self.storage = instance
        
        return instance
    }
}

// MARK: - ImmediatelyDestroyable
extension InterfaceOrientationManager: ImmediatelyDestroyable {
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
}
