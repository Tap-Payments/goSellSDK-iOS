//
//  ThemeSettings.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapVisualEffectView.TapBlurEffectStyle
import class UIKit.NSParagraphStyle.NSMutableParagraphStyle
import enum UIKit.UITextInputTraits.UIKeyboardAppearance

internal struct ThemeSettings {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let keyboardStyle: UIKeyboardAppearance
    internal let backgroundBlurStyle: TapBlurEffectStyle
    
    internal let cardInputFieldsSettings: CardInputFieldsThemeSettings
}

internal extension Theme {
    
    internal var settings: ThemeSettings {
        
        guard let storedValue = type(of: self).settingsStorage[self] else {
            
            fatalError("Theme settings are not set up correctly.")
        }
        
        return storedValue
    }
    
    internal static let settingsStorage: [Theme: ThemeSettings] = {
        
        var result: [Theme: ThemeSettings] = [:]
        
        let lightTheme: ThemeSettings = {
           
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let validCardInformationTextSetting         = TextThemeSettings(.helveticaNeueLight(15.0), .hex("#535353FF"), paragraphStyle)
            let invalidCardInformationTextSettings      = TextThemeSettings(.helveticaNeueLight(15.0), .hex("#EE0000FF"), paragraphStyle)
            let placeholderCardInformationTextSettings  = TextThemeSettings(.helveticaNeueLight(15.0), .hex("#BDBDBDFF"), paragraphStyle)
            
            let cardInputSettings = CardInputFieldsThemeSettings(valid: validCardInformationTextSetting,
                                                                 invalid: invalidCardInformationTextSettings,
                                                                 placeholder: placeholderCardInformationTextSettings)
            
            let keyboardStyle = UIKeyboardAppearance.light
            let backgroundBlurStyle = TapBlurEffectStyle.extraLight
            
            let result = ThemeSettings(keyboardStyle: keyboardStyle,
                                       backgroundBlurStyle: backgroundBlurStyle,
                                       cardInputFieldsSettings: cardInputSettings)
            
            return result
        }()
        
        result[.light] = lightTheme
        
        return result
    }()
}
