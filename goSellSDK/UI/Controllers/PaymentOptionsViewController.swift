//
//  PaymentOptionsViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct UIKit.UIGeometry.UIEdgeInsets
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UITableView.UITableView
import let UIKit.UITableView.UITableViewAutomaticDimension
import class UIKit.UIViewController.UIViewController

internal class PaymentOptionsViewController: UIViewController {
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.subscribeNotifications()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let currencySelectionController = segue.destination as? CurrencySelectionViewController {
            
            PaymentDataManager.shared.prepareCurrencySelectionController(currencySelectionController)
        }
        else if let cardScannerController = segue.destination as? CardScannerViewController {
            
            PaymentDataManager.shared.prepareCardScannerController(cardScannerController)
        }
        else if let addressInputController = segue.destination as? AddressInputViewController {
            
            PaymentDataManager.shared.prepareAddressInputController(addressInputController)
        }
    }
    
    deinit {
        
        self.unsubscribeNotifications()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
            
            PaymentDataManager.shared.paymentOptionCellViewModels.forEach { $0.tableView = self.paymentOptionsTableView }
            
            self.paymentOptionsTableView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
            self.paymentOptionsTableView?.rowHeight = UITableViewAutomaticDimension
            self.paymentOptionsTableView?.estimatedRowHeight = 100.0
        }
    }
    
    // MARK: Methods
    
    private func subscribeNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(paymentOptionsUpdated(_:)), name: .paymentOptionsModelsUpdated, object: nil)
    }
    
    private func unsubscribeNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .paymentOptionsModelsUpdated, object: nil)
    }
    
    @objc private func paymentOptionsUpdated(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.paymentOptionsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}
