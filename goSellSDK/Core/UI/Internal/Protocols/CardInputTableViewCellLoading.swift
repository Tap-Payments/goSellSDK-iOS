//
//  CardInputTableViewCellLoading.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import struct	TapBundleLocalization.LocalizationKey
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIImage.UIImage
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate

internal protocol CardInputTableViewCellLoading where Self: CardInputTableViewCellModel {
    
    var displaysAddressFields:      Bool                                        { get }
    var showsSaveCardSection:       Bool                                        { get }
    var addressOnCardTextColor:     UIColor                                     { get }
    var addressOnCardTextFont:      UIFont                                      { get }
    var addressOnCardText:          String                                      { get }
    var isSelected:                 Bool                                        { get }
    var addressOnCardArrowImage:    UIImage                                     { get }
    var scanButtonImage:            UIImage                                     { get }
    var isScanButtonVisible:        Bool                                        { get }
	var showsSaveCardSwitch:		Bool										{ get }
    var tableViewHandler:           UITableViewDataSource & UITableViewDelegate { get }
	var saveCardDescriptionKey:		LocalizationKey								{ get }
}
