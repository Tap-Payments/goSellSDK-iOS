//
//  CardInputTableViewCellLoading.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIImage.UIImage
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate

internal protocol CardInputTableViewCellLoading where Self: CardInputTableViewCellModel {
    
    var displaysAddressFields:      Bool                                        { get }
    var addressOnCardTextColor:     UIColor                                     { get }
    var addressOnCardTextFont:      UIFont                                      { get }
    var addressOnCardText:          String                                      { get }
    var isSelected:                 Bool                                        { get }
    var addressOnCardArrowImage:    UIImage                                     { get }
    var scanButtonImage:            UIImage                                     { get }
    var isScanButtonVisible:        Bool                                        { get }
    var tableViewHandler:           UITableViewDataSource & UITableViewDelegate { get }
}
