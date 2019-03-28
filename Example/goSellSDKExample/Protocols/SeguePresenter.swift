//
//  SeguePresenter.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class UIKit.UIViewController.UIViewController

internal protocol SeguePresenter where Self: UIViewController { }

internal extension SeguePresenter {
    
    func show(_ controller: UIViewController.Type) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(controller.tap_className)Segue", sender: self)
        }
    }
}
