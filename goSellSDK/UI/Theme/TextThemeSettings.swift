//
//  TextThemeSettings.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.NSParagraphStyle.NSParagraphStyle
import class UIKit.UIColor.UIColor
import class UIKit.UIFont.UIFont

internal struct TextThemeSettings {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let font: UIFont
    
    internal let color: UIColor
    
    internal let paragraphStyle: NSParagraphStyle
    
    internal var asStringAttributes: [NSAttributedStringKey: Any] {
        
        return [
            
            .foregroundColor: self.color,
            .font: self.font,
            .paragraphStyle: self.paragraphStyle
        ]
    }
    
    // MARK: Methods
    
    internal init(_ font: UIFont, _ color: UIColor, _ paragraphStyle: NSParagraphStyle) {
        
        self.font = font
        self.color = color
        self.paragraphStyle = paragraphStyle
    }
}
