//
//  InstantiatableFromStoryboard.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UIStoryboard.UIStoryboard
import class    UIKit.UIViewController.UIViewController

internal protocol InstantiatableFromStoryboard where Self: UIViewController {
    
    static var hostingStoryboard: UIStoryboard { get }
}

internal extension InstantiatableFromStoryboard {
    
    static func instantiate() -> Self {
        
        let identifier = self.tap_className
        guard let result = self.hostingStoryboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            
            fatalError("Unable to load \(identifier) from storyboard.")
        }
        
        return result
    }
}
