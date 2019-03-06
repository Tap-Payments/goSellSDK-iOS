//
//  AppDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    Crashlytics.Crashlytics
import class    Fabric.Fabric
import class    goSellSDK.goSellSDK
import class    goSellSDK.SecretKey
import class    UIKit.UIApplication.UIApplication
import protocol UIKit.UIApplication.UIApplicationDelegate
import struct	UIKit.UIApplication.UIInterfaceOrientationMask
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIWindow.UIWindow

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?
    
    internal func applicationDidFinishLaunching(_ application: UIApplication) {
        
        Fabric.with([Crashlytics.self])
        
        Serializer.markAllCustomersAsSandboxIfNotYet()
		
		goSellSDK.secretKey = SecretKey(sandbox:	"sk_test_kovrMB0mupFJXfNZWx6Etg5y",
										production:	"sk_live_QglH8V7Fw6NPAom4qRcynDK2")
    }
	
	internal func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		
		return (self.window?.isKeyWindow ?? false) ? .all : .portrait
	}
}
