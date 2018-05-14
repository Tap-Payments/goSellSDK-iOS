//
//  ThemeSettings.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapVisualEffectView.TapBlurEffectStyle
import class UIKit.NSParagraphStyle.NSMutableParagraphStyle
import class UIKit.UIImage.UIImage
import enum UIKit.UITextInputTraits.UIKeyboardAppearance

internal struct ThemeSettings {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let headerSettings: HeaderSettings
    
    internal let payButtonSettings: PayButtonSettings
    internal let billIcon: UIImage
    
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
            
            let cardInputSettings = CardInputFieldsThemeSettings(scanIcon: .named("btn_scan", in: .goSellSDKResources)!,
                                                                 valid: validCardInformationTextSetting,
                                                                 invalid: invalidCardInformationTextSettings,
                                                                 placeholder: placeholderCardInformationTextSettings)
            
            let keyboardStyle = UIKeyboardAppearance.light
            let backgroundBlurStyle = TapBlurEffectStyle.extraLight
            
            let enabledPayButtonSettings = PayButtonStateSettings(backgroundColor: .hex("#2ACE00"),
                                                                  loaderColor: .hex("#FFFFFF"),
                                                                  textFont: .helveticaNeueMedium(17.0),
                                                                  textColor: .hex("#FFFFFF"),
                                                                  securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            let disabledPayButtonSettings = PayButtonStateSettings(backgroundColor: .hex("#C9C9C9"),
                                                                   loaderColor: .hex("FFFFFF"),
                                                                   textFont: .helveticaNeueMedium(17.0),
                                                                   textColor: .hex("#FFFFFF"),
                                                                   securityIcon: UIImage.named("btn_security", in: .goSellSDKResources)!)
            let highlightedPayButtonSettings = PayButtonStateSettings(backgroundColor: .hex("#1E9A00"),
                                                                  loaderColor: .hex("#FFFFFF"),
                                                                  textFont: .helveticaNeueMedium(17.0),
                                                                  textColor: .hex("#FFFFFF"),
                                                                  securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            
            let payButtonSettings = PayButtonSettings(enabled: enabledPayButtonSettings,
                                                      disabled: disabledPayButtonSettings,
                                                      highlighted: highlightedPayButtonSettings)
            
            let headerSettings = HeaderSettings(placeholderLogo: .named("ic_merchant_logo_placeholder", in: .goSellSDKResources)!,
                                                logoLoaderColor: .hex("#535353"),
                                                textColor: .hex("#535353"),
                                                backgroundColor: .hex("#B5B5B5A8"),
                                                closeImage: .named("ic_close", in: .goSellSDKResources)!)
            
            let result = ThemeSettings(headerSettings: headerSettings,
                                       payButtonSettings: payButtonSettings,
                                       billIcon: .named("ic_bill", in: .goSellSDKResources)!,
                                       keyboardStyle: keyboardStyle,
                                       backgroundBlurStyle: backgroundBlurStyle,
                                       cardInputFieldsSettings: cardInputSettings)
            
            return result
        }()
        
        result[.light] = lightTheme
        
        return result
    }()
}
