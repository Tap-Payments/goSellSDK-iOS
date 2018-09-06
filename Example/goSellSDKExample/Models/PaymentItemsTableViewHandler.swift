//
//  PaymentItemsTableViewHandler.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   Foundation.NSDecimal.Decimal
import struct   Foundation.NSIndexPath.IndexPath
import class    goSellSDK.PaymentItem
import class    ObjectiveC.NSObject.NSObject
import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableViewCell.UITableViewCell

internal protocol PaymentItemsProvider {
    
    var paymentItems: [PaymentItem] { get }
}

internal final class PaymentItemsTableViewHandler: NSObject {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(itemsProvider: PaymentItemsProvider, tableView: UITableView) {
        
        self.itemsProvider = itemsProvider
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    internal func reloadData() {
        
        self.generateCellModels()
        self.tableView.reloadData()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let itemsProvider: PaymentItemsProvider
    private let tableView: UITableView
    
    private var cellModels: [TableViewCellModel] = []
    
    // MARK: Methods
    
    private func generateCellModels() {
        
        var result: [TableViewCellModel] = []
        
        let paymentItemsCount = self.itemsProvider.paymentItems.count
        if paymentItemsCount > 0 {
            
            if paymentItemsCount > 1 {
                
                let groupCellModel = GroupHeaderCellModel(title: "Select items from the list below:")
                result.append(groupCellModel)
            }
            else {
                
                let groupCellModel = GroupHeaderCellModel(title: "Select an item below:")
                result.append(groupCellModel)
            }
            
            self.itemsProvider.paymentItems.forEach {
                
                let itemCellModel = PaymentItemTableViewCellModel(paymentItem: $0)
                result.append(itemCellModel)
            }
            
            let plainAmountGroupModel = GroupHeaderCellModel(title: "Or just type plain amount:")
            result.append(plainAmountGroupModel)
        }
        else {
            
            let plainAmountGroupModel = GroupHeaderCellModel(title: "Just type plain amount:")
            result.append(plainAmountGroupModel)
        }
        
        if let amountModel = self.cellModels.first(where: { $0 is PlainAmountTableViewCellModel }) as? PlainAmountTableViewCellModel {
            
            result.append(amountModel)
        }
        else {
            
            let amountModel = PlainAmountTableViewCellModel(amount: 0.0)
            result.append(amountModel)
        }
        
        self.cellModels = result
    }
}

// MARK: - UITableViewDataSource
extension PaymentItemsTableViewHandler: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cellModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.cellModels[indexPath.row]
        
        if model is GroupHeaderCellModel {
            
            return tableView.dequeueReusableCell(withIdentifier: GroupHeaderCell.className)!
        }
        else if model is PaymentItemTableViewCellModel {
            
            return tableView.dequeueReusableCell(withIdentifier: PaymentItemTableViewCell.className)!
        }
        else if model is PlainAmountTableViewCellModel {
            
            return tableView.dequeueReusableCell(withIdentifier: PlainAmountTableViewCell.className)!
        }
        else {
            
            fatalError("Data source corrupted.")
        }
    }
}

// MARK: - UITableViewDelegate
extension PaymentItemsTableViewHandler: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let groupHeaderCell = cell as? GroupHeaderCell, let model = self.cellModels[indexPath.row] as? GroupHeaderCellModel {
            
            groupHeaderCell.setGroupTitle(model.title)
        }
        else if let paymentItemCell = cell as? PaymentItemTableViewCell, let model = self.cellModels[indexPath.row] as? PaymentItemTableViewCellModel {
            
            let item = model.paymentItem
            
            let itemTitle           = item.title
            let quantityValue       = "\(item.quantity.value)"
            let quantityMeasurement = item.quantity.measurementUnit
            let price               = "\(item.amountPerUnit)"
            let amount              = "\(item.plainAmount)"
            let discount            = "\(item.discountAmount)"
            let taxes               = "\(item.taxesAmount)"
            let total               = "\(item.totalItemAmount)"
            
            paymentItemCell.setTitle(                       itemTitle,
                                     quantityValue:         quantityValue,
                                     quantityMeasurement:   quantityMeasurement,
                                     price:                 price,
                                     amount:                amount,
                                     discount:              discount,
                                     taxes:                 taxes,
                                     total:                 total)
        }
        else if let plainAmountCell = cell as? PlainAmountTableViewCell, let model = self.cellModels[indexPath.row] as? PlainAmountTableViewCellModel {
            
            plainAmountCell.setAmount(model.amount)
        }
    }
}
