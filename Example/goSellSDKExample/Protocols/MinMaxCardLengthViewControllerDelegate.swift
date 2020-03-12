//
//  MinMaxCardLengthViewControllerDelegate.swift
//  goSellSDKExample
//
//  Created by Osama Rabie on 12/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

internal protocol MinMaxCardLengthViewControllerDelegate: class {
    
    func minMaxCardLengthViewControllerViewController(_ controller: MinMaxCardLengthViewController, didFinishWith min: Int, max: Int)
}

