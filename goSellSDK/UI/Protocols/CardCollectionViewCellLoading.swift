//
//  CardCollectionViewCellLoading.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class    UIKit.UIImage.UIImage

internal protocol CardCollectionViewCellLoading: ClassProtocol {
    
    var isSelected:         Bool        { get }
    var smallImage:         UIImage?    { get }
    var bigImage:           UIImage     { get }
    var checkmarkImage:     UIImage     { get }
    var currencyLabelText:  String      { get }
    var cardNumberText:     String      { get }
    
    var deleteCardImage:    UIImage     { get }
    
    var isDeleteCellMode:   Bool        { get set }
    
    func deleteCardButtonClicked()
}
