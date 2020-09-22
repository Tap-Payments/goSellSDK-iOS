//
//  CardCollectionViewCellLoading.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import class    UIKit.UIImage.UIImage

internal protocol CardCollectionViewCellLoading: ClassProtocol {
    
    var isSelected:         Bool        { get }
    var smallImage:         UIImage?    { get }
    var bigImage:           UIImage     { get }
    var checkmarkImage:     UIImage     { get }
    var currencyLabelText:  String      { get }
    var cardNumberText:     String      { get }
    
    var deleteCardImage:    UIImage     { get }
    
    var isDeleteCellMode:   Bool        { get }
	
	func cellTapDetected()
	
	func cellLongPressDetected()
	
    func deleteCardButtonClicked()
}
