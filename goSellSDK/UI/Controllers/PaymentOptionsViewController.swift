//
//  PaymentOptionsViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIViewController.UIViewController

internal class PaymentOptionsViewController: UIViewController {
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
            
            PaymentDataManager.shared.paymentOptionCellViewModels.forEach { $0.tableView = self.paymentOptionsTableView }
            
            self.paymentOptionsTableView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
            self.paymentOptionsTableView?.rowHeight = UITableViewAutomaticDimension
            self.paymentOptionsTableView?.estimatedRowHeight = UITableViewAutomaticDimension
        }
    }
}
