//
//  AppDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
//  Shared by both examples: ../Example (CocoaPods) and ../ExampleSPM (Swift Package Manager).
//

import class    goSellSDK.GoSellSDK
import class    goSellSDK.SecretKey
import class    UIKit.UIApplication.UIApplication
import protocol UIKit.UIApplication.UIApplicationDelegate
import struct	UIKit.UIApplication.UIInterfaceOrientationMask
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIWindow.UIWindow
import protocol UIKit.UIWindowScene.UIWindowSceneDelegate

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    internal func applicationDidFinishLaunching(_ application: UIApplication) {

        Serializer.markAllCustomersAsSandboxIfNotYet()

        GoSellSDK.secretKey = SecretKey(sandbox:    "YOUR_SANDBOX_SECRET_KEY",
                                        production:    "YOUR_PRODUCTION_SECRET_KEY")
    }

    internal func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        // Allow every orientation and let each screen decide; goSellSDK keeps its payment sheet in
        // portrait on phones and follows the device on iPads and unfolded foldable iPhones.
        return .all
    }
}

/// Apps built with the iOS 27 SDK must use the UIScene life cycle. The window comes from Main.storyboard
/// (UISceneStoryboardFile in Info.plist).
internal class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    internal var window: UIWindow?
}
