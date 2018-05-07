//
//  UIFont+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension UIFont {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func helveticaNeueLight(_ size: CGFloat) -> UIFont {
        
        return .with(name: Constants.helveticaNeueLightFontName, size: size)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let helveticaNeueLightFontName = "HelveticaNeue-Light"
    }
    
    // MARK: Methods
    
    private static func with(name: String, size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: name, size: size) else {
            
            fatalError("There is no font with name \(name)")
        }
        
        return font
    }
}
