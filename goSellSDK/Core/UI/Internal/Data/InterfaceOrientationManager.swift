//
//  InterfaceOrientationManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import TapAdditionsKitV2
import UIKit
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
        
        return self.followsDeviceOrientation(controller)
    }
    
    internal func supportedInterfaceOrientations(for controller: UIViewController) -> UIInterfaceOrientationMask {
        
        return self.followsDeviceOrientation(controller) ? .all : .portrait
    }
    
    internal func preferredInterfaceOrientationForPresentation(of controller: UIViewController) -> UIInterfaceOrientation {
        
        guard self.followsDeviceOrientation(controller) else { return .portrait }
        
        let currentOrientation = self.windowScene(for: controller)?.interfaceOrientation ?? .unknown
        return currentOrientation == .unknown ? .portrait : currentOrientation
    }
    
    /// Applies the current rules to the separate window that shows `controller` and asks UIKit to
    /// re-check the supported orientations. Called after a size change, e.g. when a foldable iPhone
    /// is folded or unfolded while the payment sheet is open.
    internal func updateSupportedOrientations(after controller: UIViewController) {
        
        guard let window = controller.viewIfLoaded?.window else { return }
        
        if let rootController = window.rootViewController as? SeparateWindowRootViewController {
            
            self.configure(rootController)
        }
        
        if #available(iOS 16.0, *) {
            
            window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            controller.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        else {
            
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    /// Sets the orientation rules on the root controller of a separate window.
    internal func configure(_ rootController: SeparateWindowRootViewController) {
        
        rootController.allowedInterfaceOrientations   = self.supportedInterfaceOrientations(for: rootController)
        rootController.preferredInterfaceOrientation  = self.preferredInterfaceOrientationForPresentation(of: rootController)
        rootController.canAutorotate                  = self.viewControllerShouldAutorotate(rootController)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        /// Shortest side, in points, from which a window counts as large. Every iPhone screen is
        /// narrower (440 pt at most); iPads (744 pt and up) and the unfolded inner panel of a
        /// foldable iPhone are wider.
        fileprivate static let largeWindowMinimalSide: CGFloat = 600.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    /// Phones keep the payment sheet in portrait. iPads, and phones whose window is iPad-sized
    /// (the unfolded inner panel of a foldable iPhone, which is landscape), follow the device so the
    /// sheet is never drawn sideways.
    private func followsDeviceOrientation(_ controller: UIViewController) -> Bool {
        
        if UIDevice.current.tap_isIPad {
            
            return true
        }
        
        guard let bounds = self.windowScene(for: controller)?.coordinateSpace.bounds else { return false }
        
        return min(bounds.width, bounds.height) >= Constants.largeWindowMinimalSide
    }
    
    private func windowScene(for controller: UIViewController) -> UIWindowScene? {
        
        return controller.viewIfLoaded?.window?.windowScene ?? UIApplication.shared.tap_foregroundKeyWindow?.windowScene
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
