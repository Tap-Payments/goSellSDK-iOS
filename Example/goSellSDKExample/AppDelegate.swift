//
//  AppDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.goSellSDK
import class UIKit.UIApplication.UIApplication
import protocol UIKit.UIApplication.UIApplicationDelegate
import class UIKit.UIResponder.UIResponder
import class UIKit.UIWindow.UIWindow

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    internal func applicationDidFinishLaunching(_ application: UIApplication) {
        
        goSellSDK.secretKey = "YOUR_SANDBOX_SECRET_KEY" //+ "_zalupa"
    }
}
