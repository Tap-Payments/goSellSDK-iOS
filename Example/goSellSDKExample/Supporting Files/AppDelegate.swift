//
//  AppDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
//  Shared by both examples: ../Example (CocoaPods) and ../ExampleSPM (Swift Package Manager).
//

import Foundation
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

        let keys = ExampleKeys.load()
        GoSellSDK.secretKey = SecretKey(sandbox:    keys.sandboxSecretKey,
                                        production:    keys.productionSecretKey)
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

/// Tap keys for the example, read from Keys.json.
///
/// Keys.json is git-ignored so keys never get committed. Copy Keys.example.json (next to this file) to
/// Keys.json and fill in your keys; a build step copies it into the app. Both examples use it.
private struct ExampleKeys: Decodable {
    
    let sandboxSecretKey: String
    let productionSecretKey: String
    
    static func load() -> ExampleKeys {
        
        guard let url = Bundle.main.url(forResource: "Keys", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let keys = try? JSONDecoder().decode(ExampleKeys.self, from: data) else {
            
            print("goSellSDKExample: Keys.json is missing or invalid. Copy Keys.example.json to Keys.json in \"Example/goSellSDKExample/Supporting Files\" and add your keys.")
            return ExampleKeys(sandboxSecretKey: "YOUR_SANDBOX_SECRET_KEY", productionSecretKey: "YOUR_PRODUCTION_SECRET_KEY")
        }
        
        return keys
    }
}
