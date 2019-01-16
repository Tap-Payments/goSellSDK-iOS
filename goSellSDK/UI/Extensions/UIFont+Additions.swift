//
//  UIFont+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import class	UIKit.UIFont.UIFont

internal extension UIFont {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func helveticaNeueLight(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueLightFontName, size: size)
    }
    
    internal static func helveticaNeueMedium(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueMediumFontName, size: size)
    }
    
    internal static func helveticaNeueRegular(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueRegularFontName, size: size)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let helveticaNeueLightFontName = "HelveticaNeue-Light"
        fileprivate static let helveticaNeueMediumFontName = "HelveticaNeue-Medium"
        fileprivate static let helveticaNeueRegularFontName = "HelveticaNeue"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    private static func with(name: String, size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: name, size: size) else {
            
            fatalError("There is no font with name \(name)")
        }
        
        return font
    }
}
