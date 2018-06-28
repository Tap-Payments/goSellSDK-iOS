//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    Dispatch.DispatchQueue
import class    goSellSDK.Currency
import class    goSellSDK.CustomerInfo
import class    goSellSDK.EmailAddress
import class    goSellSDK.PayButton
import protocol goSellSDK.PaymentDataSource
import class    goSellSDK.PaymentItem
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

internal class ExampleViewController: UIViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var paymentItems: [PaymentItem] = Serializer.deserialize()
    
    internal var selectedPaymentItems: [PaymentItem] = []
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "goSell SDK Example"
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.updatePayButtonStateAndAmount()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let paymentController = (segue.destination as? UINavigationController)?.rootViewController as? PaymentItemViewController {
            
            paymentController.delegate = self
            paymentController.paymentItem = self.selectedPaymentItem
        }
        else if let settingsController = (segue.destination as? UINavigationController)?.rootViewController as? SettingsTableViewController {
            
            settingsController.delegate = self
            settingsController.settings = self.paymentSettings
        }
    }
    
    internal func showPaymentItemViewController(with item: PaymentItem? = nil) {
        
        self.selectedPaymentItem = item
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(PaymentItemViewController.className)Segue", sender: self)
        }
    }
    
    internal func updatePayButtonStateAndAmount() {
        
        self.payButton?.updateDisplayedStateAndAmount()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var paymentSettings: Settings = Serializer.deserialize() ?? .default
    
    @IBOutlet private weak var itemsTableView: UITableView? {
        
        didSet {
            
            self.itemsTableView?.tableFooterView = UIView()
        }
    }
    
    @IBOutlet private weak var payButton: PayButton?
    
    internal var selectedPaymentItem: PaymentItem?
    
    // MARK: Methods
    
    @IBAction private func addButtonTouchUpInside(_ sender: Any) {
        
        self.showPaymentItemViewController()
    }
}

// MARK: - PaymentItemViewControllerDelegate
extension ExampleViewController: PaymentItemViewControllerDelegate {
    
    internal func paymentItemViewController(_ controller: PaymentItemViewController, didFinishWith item: PaymentItem) {
        
        if let nonnullSelectedItem = self.selectedPaymentItem {
            
            if let index = self.paymentItems.index(of: nonnullSelectedItem) {
                
                if let selectedIndex = self.selectedPaymentItems.index(of: nonnullSelectedItem) {
                    
                    self.selectedPaymentItems.remove(at: selectedIndex)
                    self.selectedPaymentItems.append(item)
                }
                
                self.paymentItems.remove(at: index)
                self.paymentItems.insert(item, at: index)
            }
            else {
                
                self.paymentItems.append(item)
            }
        }
        else {
            
            self.paymentItems.append(item)
        }
        
        Serializer.serialize(self.paymentItems)
        
        self.itemsTableView?.reloadData()
    }
}

// MARK: - SettingsTableViewControlerDelegate
extension ExampleViewController: SettingsTableViewControlerDelegate {
    
    internal func settingsViewController(_ controller: SettingsTableViewController, didFinishWith settings: Settings) {
        
        self.paymentSettings = settings
        Serializer.serialize(settings)
    }
}

// MARK: - PaymentDataSource
extension ExampleViewController: PaymentDataSource {
    
    internal var customer: CustomerInfo? {
        
        return self.paymentSettings.customer
    }
    
    internal var items: [PaymentItem] {
        
        return self.selectedPaymentItems
    }
    
    internal var currency: Currency? {
        
        return self.paymentSettings.currency
    }
    
    internal var shipping: [Shipping]? {
        
        return self.paymentSettings.shippingList
    }
    
    internal var taxes: [Tax]? {
        
        return self.paymentSettings.taxes
    }
    
    internal var require3DSecure: Bool {
        
        return true
    }
}
