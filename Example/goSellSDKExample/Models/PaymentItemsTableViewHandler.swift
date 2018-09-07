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
import class    UIKit.UITableView.UITableViewRowAction
import class    UIKit.UITableViewCell.UITableViewCell

internal protocol PaymentItemsProvider {
    
    var paymentItems: [PaymentItem] { get }
}

internal protocol PaymentItemsTableViewCallbacksHandler {
    
    func accessoryButtonTappedForCell(with item: PaymentItem)
    func removePaymentItem(_ item: PaymentItem)
    func selectionChanged(_ items: [PaymentItem]?, plainAmount: Decimal?)
}

internal final class PaymentItemsTableViewHandler: NSObject {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(itemsProvider: PaymentItemsProvider, tableView: UITableView, callbacksHandler: PaymentItemsTableViewCallbacksHandler) {
        
        self.itemsProvider = itemsProvider
        self.tableView = tableView
        self.callbacksHandler = callbacksHandler
        
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
    private let callbacksHandler: PaymentItemsTableViewCallbacksHandler
    private let tableView: UITableView
    
    private var cellModels: [TableViewCellModel] = []
    
    private var selectedItems: [PaymentItem]? {
        
        let selectedModels = self.selectedModels(of: PaymentItemTableViewCellModel.self)
        return selectedModels.isEmpty ? nil : selectedModels.map { $0.paymentItem }
    }
    
    private var plainAmount: Decimal? {
        
        let selectedModels = self.selectedModels(of: PlainAmountTableViewCellModel.self)
        return selectedModels.first?.amount
    }
    
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
            
            let amountModel = PlainAmountTableViewCellModel(amountString: .empty, changeObserver: self)
            result.append(amountModel)
        }
        
        self.cellModels = result
    }
    
    private func selectedModels<Type: TableViewCellModel>(of type: Type.Type) -> [Type] {
        
        return self.cellModels.filter({ $0.isSelected }).compactMap { $0 as? Type }
    }
    
    private func deselectAllCellsForModels(of modelType: TableViewCellModel.Type) {
        
        self.cellModels.forEach { if type(of: $0) == modelType { $0.isSelected = false } }
        self.tableView.reloadVisibleCells()
    }
}

// MARK: - AmountChangeObserver
extension PaymentItemsTableViewHandler: AmountChangeObserver {
    
    internal func amountChanged(_ amount: Decimal) {
        
        self.callbacksHandler.selectionChanged(self.selectedItems, plainAmount: self.plainAmount)
    }
}

// MARK: - UITableViewDataSource
extension PaymentItemsTableViewHandler: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cellModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.cellModels[indexPath.row]
        return tableView.dequeueReusableCell(withIdentifier: type(of: model).cellClass.className)!
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
            
            plainAmountCell.setAmountText(model.amountString, changeListener: model)
        }
        
        if cell is SelectableCell {
            
            let model = self.cellModels[indexPath.row]
            
            if model.isSelected {
                
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            else {
                
                tableView.deselectRow(at: indexPath, animated: false)
            }
            
            cell.setSelected(model.isSelected, animated: false)
        }
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let model = self.cellModels[indexPath.row]
        return type(of: model).cellClass.isSubclass(of: SelectableCell.self) ? indexPath : nil
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemModel = self.cellModels[indexPath.row] as? PaymentItemTableViewCellModel {
            
            itemModel.isSelected = true
            self.deselectAllCellsForModels(of: PlainAmountTableViewCellModel.self)
            self.callbacksHandler.selectionChanged(self.selectedItems, plainAmount: self.plainAmount)
        }
        else if let amountModel = self.cellModels[indexPath.row] as? PlainAmountTableViewCellModel {
            
            amountModel.isSelected = true
            self.deselectAllCellsForModels(of: PaymentItemTableViewCellModel.self)
            self.callbacksHandler.selectionChanged(self.selectedItems, plainAmount: self.plainAmount)
        }
        else {
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let model = self.cellModels[indexPath.row]
        model.isSelected = false
        
        self.callbacksHandler.selectionChanged(self.selectedItems, plainAmount: self.plainAmount)
    }
    
    internal func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard let model = self.cellModels[indexPath.row] as? PaymentItemTableViewCellModel else { return }
        self.callbacksHandler.accessoryButtonTappedForCell(with: model.paymentItem)
    }
    
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if let model = self.cellModels[indexPath.row] as? PaymentItemTableViewCellModel {
            
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, cellIndexPath) in
                
                self?.callbacksHandler.removePaymentItem(model.paymentItem)
                self?.tableView.deleteRows(at: [cellIndexPath], with: .automatic)
            }
            
            return [deleteAction]
        }
        else {
            
            return nil
        }
    }
}
