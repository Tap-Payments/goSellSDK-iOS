//
//  InteractivePopViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
@objc internal protocol InteractivePopViewController {
    
    var interactivePopTransition: UINavigationControllerPopInteractionController? { get }
}

