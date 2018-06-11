//
//  ExampleViewController+UITableView.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   Foundation.NSIndexPath.IndexPath
import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableView.UITableViewRowAction
import class    UIKit.UITableViewCell.UITableViewCell

extension ExampleViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.paymentItems.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentItemTableViewCell.className) as? PaymentItemTableViewCell else {
            
            fatalError("Failed to load \(PaymentItemTableViewCell.className) from storyboard.")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExampleViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let itemCell = cell as? PaymentItemTableViewCell else {
            
            fatalError("Somehow cell class is incorrect.")
        }
        
        let item = self.paymentItems[indexPath.row]
        
        let selected = self.selectedPaymentItems.contains(item)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        itemCell.setSelected(selected, animated: false)
        
        let itemTitle = item.title
        let quantityValue = "\(item.quantity.value)"
        let quantityMeasurement = item.quantity.measurementUnit
        let price = "\(item.amountPerUnit)"
        let amount = "\(item.plainAmount)"
        let discount = "\(item.discountAmount)"
        let taxes = "\(item.taxesAmount)"
        let total = "\(item.totalItemAmount)"
        
        itemCell.setTitle(itemTitle,
                          quantityValue: quantityValue,
                          quantityMeasurement: quantityMeasurement,
                          price: price,
                          amount: amount,
                          discount: discount,
                          taxes: taxes,
                          total: total)
    }
    
    internal func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let item = self.paymentItems[indexPath.row]
        self.showPaymentItemViewController(with: item)
    }
    
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
            
            self.paymentItems.remove(at: cellIndexPath.row)
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.paymentItems[indexPath.row]
        self.selectedPaymentItems.append(item)
        
        self.updatePayButtonStateAndAmount()
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let item = self.paymentItems[indexPath.row]
        if let index = self.selectedPaymentItems.index(of: item) {
            
            self.selectedPaymentItems.remove(at: index)
        }
        
        self.updatePayButtonStateAndAmount()
    }
    
    private func tableViewSelectionChanged() {
        
        self.updatePayButtonStateAndAmount()
    }
}
