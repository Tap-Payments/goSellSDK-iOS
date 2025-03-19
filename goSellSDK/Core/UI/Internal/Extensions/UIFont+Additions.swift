//
//  UIFont+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIFont.UIFont

internal extension UIFont {
    
    // MARK: - Internal -
    // MARK: Methods
    
    static func helveticaNeueLight(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueLightFontName, size: size)
    }
    
    static func helveticaNeueMedium(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueMediumFontName, size: size)
    }
    
    static func helveticaNeueRegular(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueRegularFontName, size: size)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let helveticaNeueLightFontName = "HelveticaNeue-Light"
        fileprivate static let helveticaNeueMediumFontName = "HelveticaNeue-Medium"
        fileprivate static let helveticaNeueRegularFontName = "HelveticaNeue"
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Methods
    
    private static func with(name: String, size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: name, size: size) else {
            
            fatalError("There is no font with name \(name)")
        }
        
        return font
    }
    
    static func loadSARFont() {
        guard let fontURL = Bundle.goSellSDKResources.url(forResource: "sar-Regular", withExtension: "ttf") else {
            return
        }
        guard let fontData = try? Data(contentsOf: fontURL) else {
            print("Failed to load  from fonts bundle.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
            print("Font data for  is incorrect.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            
            print("Font data for  is incorrect.")
            return
        }
        var error: Unmanaged<CFError>? = nil
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            
            if let nonnullError = error, let errorDescription = CFErrorCopyDescription(nonnullError.takeRetainedValue()) {
                print("Error occured while registering font: \(errorDescription)")
            }
        }
    }
}
