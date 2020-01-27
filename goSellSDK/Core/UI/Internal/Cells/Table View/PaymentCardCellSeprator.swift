//
//  PaymentCardCellSeprator.swift
//  goSellSDK
//
//  Created by Osama Rabie on 27/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

class PaymentCardCellSeprator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        fillBackGroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fillBackGroundColor()
    }
    
    
    func fillBackGroundColor()
    {
        self.backgroundColor = UIColor.init(tap_hex: "E1E1E1")?.loadCompatibleDarkModeColor(forColorNamed: "DefaultCardSeparatorColor")
    }
    
}

