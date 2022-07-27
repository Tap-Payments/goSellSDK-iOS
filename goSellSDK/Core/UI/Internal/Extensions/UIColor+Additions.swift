//
//  UIColor+Additions.swift
//  goSellSDK
//
//  Created by Osama Rabie on 21/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

internal extension UIColor
{
    func loadCompatibleDarkModeColor(forColorNamed:String)->UIColor
    {
        
        if #available(iOS 13.0, *), Process.shared.externalSession?.dataSource?.uiModeDisplay?.userInterface == .dark {
            
            if let color = UIColor(named: forColorNamed, in: .goSellSDKResources, compatibleWith: nil)
            {
                return color
            }
       }
        return self
    }
}
