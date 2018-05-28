//
//  ExampleViewController+UITableView.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/25/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSIndexPath.IndexPath
import class UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class UIKit.UITableViewCell.UITableViewCell

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
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.paymentItems[indexPath.row]
        self.showPaymentItemViewController(with: item)
    }
}
