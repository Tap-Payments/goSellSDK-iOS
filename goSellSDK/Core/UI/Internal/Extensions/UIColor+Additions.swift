//
//  UIColor+Additions.swift
//  goSellSDK
//
//  Created by Osama Rabie on 21/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import class UIKit.UIColor

internal extension UIColor
{
    func loadCompatibleDarkModeColor(forColorNamed:String)->UIColor
    {
        
        if #available(iOS 11.0, *) {
            if let color = UIColor(named: forColorNamed, in: .goSellSDKResources, compatibleWith: nil)
            {
                return color
            }
       }
        return self
    }
}
