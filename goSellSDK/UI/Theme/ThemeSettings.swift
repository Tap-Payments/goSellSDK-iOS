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
    
    internal let payButtonSettings: TapButtonSettings
    internal let otpConfirmationButtonSettings: TapButtonSettings
    
    internal let billIcon: UIImage
    
    internal let loaderAnimationDuration: TimeInterval
    
    internal let keyboardStyle: UIKeyboardAppearance
    internal let backgroundBlurStyle: TapBlurEffectStyle
    
    internal let cardInputFieldsSettings: CardInputFieldsThemeSettings
    
    internal let generalImages: GeneralImages
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
            
            let enabledPayButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#2ACE00"),
                                                                  loaderColor: .hex("#FFFFFF"),
                                                                  textFont: .helveticaNeueMedium(17.0),
                                                                  textColor: .hex("#FFFFFF"),
                                                                  securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            let disabledPayButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#C9C9C9"),
                                                                   loaderColor: .hex("FFFFFF"),
                                                                   textFont: .helveticaNeueMedium(17.0),
                                                                   textColor: .hex("#FFFFFF"),
                                                                   securityIcon: UIImage.named("btn_security", in: .goSellSDKResources)!)
            let highlightedPayButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#1E9A00"),
                                                                      loaderColor: .hex("#FFFFFF"),
                                                                      textFont: .helveticaNeueMedium(17.0),
                                                                      textColor: .hex("#FFFFFF"),
                                                                      securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            
            let payButtonSettings = TapButtonSettings(enabled: enabledPayButtonSettings,
                                                      disabled: disabledPayButtonSettings,
                                                      highlighted: highlightedPayButtonSettings)
            
            let enabledOTPButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#009AFF"),
                                                                  loaderColor: .hex("#FFFFFF"),
                                                                  textFont: .helveticaNeueMedium(17.0),
                                                                  textColor: .hex("#FFFFFF"),
                                                                  securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            let disabledOTPButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#C9C9C9"),
                                                                   loaderColor: .hex("FFFFFF"),
                                                                   textFont: .helveticaNeueMedium(17.0),
                                                                   textColor: .hex("#FFFFFF"),
                                                                   securityIcon: UIImage.named("btn_security", in: .goSellSDKResources)!)
            let highlightedOTPButtonSettings = TapButtonStateSettings(backgroundColor: .hex("#007AC9"),
                                                                      loaderColor: .hex("#FFFFFF"),
                                                                      textFont: .helveticaNeueMedium(17.0),
                                                                      textColor: .hex("#FFFFFF"),
                                                                      securityIcon: .named("btn_security", in: .goSellSDKResources)!)
            
            let otpButtonSettings = TapButtonSettings(enabled: enabledOTPButtonSettings,
                                                      disabled: disabledOTPButtonSettings,
                                                      highlighted: highlightedOTPButtonSettings)
            
            let headerSettings = HeaderSettings(placeholderLogo: .named("ic_merchant_logo_placeholder", in: .goSellSDKResources)!,
                                                logoLoaderColor: .hex("#535353"),
                                                textColor: .hex("#535353"),
                                                backgroundColor: .hex("#F7F7F7"),
                                                closeImage: .named("ic_close", in: .goSellSDKResources)!)
            
            let generalImages = GeneralImages(arrowRight: .named("ic_arrow_right", in: .goSellSDKResources)!,
                                              arrowLeft: .named("ic_arrow_left", in: .goSellSDKResources)!,
                                              checkmarkImage: .named("ic_checkmark", in: .goSellSDKResources)!,
                                              closeImage: .named("ic_close", in:. goSellSDKResources)!)
            
            let result = ThemeSettings(headerSettings: headerSettings,
                                       payButtonSettings: payButtonSettings,
                                       otpConfirmationButtonSettings: otpButtonSettings,
                                       billIcon: .named("ic_bill", in: .goSellSDKResources)!,
                                       loaderAnimationDuration: 3.0,
                                       keyboardStyle: keyboardStyle,
                                       backgroundBlurStyle: backgroundBlurStyle,
                                       cardInputFieldsSettings: cardInputSettings,
                                       generalImages: generalImages)
            
            return result
        }()
        
        result[.light] = lightTheme
        
        return result
    }()
}
