//
//  ViewControllerLayoutListener.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import protocol	TapAdditionsKitV2.ClassProtocol
import class	UIKit.UIViewController.UIViewController

internal protocol ViewControllerLayoutListener: ClassProtocol {
	
	func viewControllerViewDidLayoutSubviews(_ viewController: UIViewController)
}
