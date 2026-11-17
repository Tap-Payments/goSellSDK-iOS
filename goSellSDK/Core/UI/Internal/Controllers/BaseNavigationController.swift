//
//  BaseNavigationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import enum UIKit.UIApplication.UIInterfaceOrientation
import struct UIKit.UIApplication.UIInterfaceOrientationMask
import class UIKit.UINavigationController.UINavigationController

internal class BaseNavigationController: UINavigationController {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var modalPresentationCapturesStatusBarAppearance: Bool {
		
		get {
			
			return true
		}
		set {
			
			super.modalPresentationCapturesStatusBarAppearance = true
		}
	}
	
    internal override var shouldAutorotate: Bool {
        
        return InterfaceOrientationManager.shared.viewControllerShouldAutorotate(self)
    }
    
    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return InterfaceOrientationManager.shared.supportedInterfaceOrientations(for: self)
    }
    
    internal override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return InterfaceOrientationManager.shared.preferredInterfaceOrientationForPresentation(of: self)
    }
    
    internal override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // The window may have changed between phone-sized and iPad-sized (folding a foldable iPhone).
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            
            guard let strongSelf = self else { return }
            InterfaceOrientationManager.shared.updateSupportedOrientations(after: strongSelf)
        }
    }
}
