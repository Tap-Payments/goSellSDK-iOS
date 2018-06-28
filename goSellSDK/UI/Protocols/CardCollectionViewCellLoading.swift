//
//  CardCollectionViewCellLoading.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class    UIKit.UIImage.UIImage

internal protocol CardCollectionViewCellLoading: ClassProtocol where Self: CardCollectionViewCellModel {
    
    var smallImage:         UIImage?    { get }
    var bigImage:           UIImage     { get }
    var currencyLabelText:  String      { get }
    var cardNumberText:     String      { get }
}
