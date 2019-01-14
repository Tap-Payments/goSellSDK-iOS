//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    Dispatch.DispatchQueue
import struct   Foundation.NSDecimal.Decimal
import class    goSellSDK.AmountModificator
import class    goSellSDK.Authorize
import class    goSellSDK.AuthorizeAction
import class    goSellSDK.Charge
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class    goSellSDK.EmailAddress
import class    goSellSDK.goSellSDK
import class    goSellSDK.PayButton
import protocol goSellSDK.PayButtonProtocol
import protocol goSellSDK.PaymentDataSource
import protocol goSellSDK.PaymentDelegate
import class    goSellSDK.PaymentItem
import class    goSellSDK.PhoneNumber
import class    goSellSDK.Quantity
import class    goSellSDK.Receipt
import class    goSellSDK.Reference
import class    goSellSDK.Shipping
import class    goSellSDK.TapSDKError
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

internal class ExampleViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var paymentItems: [PaymentItem] = Serializer.deserialize()
    
    internal var selectedPaymentItems: [PaymentItem]?
    internal var plainAmount: Decimal?
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "goSell SDK Example"
		self.ignoresKeyboardEventsWhenWindowIsNotKey = true
		
		goSellSDK.language = self.paymentSettings.sdkLanguage.localeIdentifier
        goSellSDK.mode = self.paymentSettings.sdkMode
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.updatePayButtonAmount()
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
    
    internal func updatePayButtonAmount() {
        
        self.payButton?.updateDisplayedAmount()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var paymentSettings: Settings = Serializer.deserialize() ?? .default {
        
        didSet {
			
			goSellSDK.language = self.paymentSettings.sdkLanguage.localeIdentifier
            goSellSDK.mode = self.paymentSettings.sdkMode
        }
    }
    
    private var tableViewHandler: PaymentItemsTableViewHandler?
    
    @IBOutlet private weak var itemsTableView: UITableView? {
        
        didSet {
            
            self.itemsTableView?.tableFooterView = UIView()
            self.createPaymentItemsTableViewHandler()
        }
    }
    
    @IBOutlet private weak var payButton: PayButton?
    
    internal var selectedPaymentItem: PaymentItem?
    
    // MARK: Methods
    
    @IBAction private func addButtonTouchUpInside(_ sender: Any) {
        
        self.showPaymentItemViewController()
    }
    
    private func createPaymentItemsTableViewHandler() {
        
        guard let nonnullTableView = self.itemsTableView else { return }
        
        self.tableViewHandler = PaymentItemsTableViewHandler(itemsProvider: self, tableView: nonnullTableView, callbacksHandler: self)
        self.tableViewHandler?.reloadData()
    }
}

// MARK: - PaymentItemsProvider
extension ExampleViewController: PaymentItemsProvider {}

// MARK: - PaymentItemsTableViewCallbacksHandler
extension ExampleViewController: PaymentItemsTableViewCallbacksHandler {
    
    internal func removePaymentItem(_ item: PaymentItem) {
        
        if let index = self.paymentItems.index(of: item) {
            
            self.paymentItems.remove(at: index)
            Serializer.serialize(self.paymentItems)
        }
    }
    
    internal func selectionChanged(_ items: [PaymentItem]?, plainAmount: Decimal?) {
        
        self.selectedPaymentItems = items
        self.plainAmount = plainAmount
        
        self.updatePayButtonAmount()
    }
    
    internal func accessoryButtonTappedForCell(with item: PaymentItem) {
    
        self.showPaymentItemViewController(with: item)
    }
}

// MARK: - PaymentItemViewControllerDelegate
extension ExampleViewController: PaymentItemViewControllerDelegate {
    
    internal func paymentItemViewController(_ controller: PaymentItemViewController, didFinishWith item: PaymentItem) {
        
        if let nonnullSelectedItem = self.selectedPaymentItem {
            
            if let index = self.paymentItems.index(of: nonnullSelectedItem) {
                
                if let selectedIndex = self.selectedPaymentItems?.index(of: nonnullSelectedItem) {
                    
                    self.selectedPaymentItems?.remove(at: selectedIndex)
                    self.selectedPaymentItems?.append(item)
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
        
        self.tableViewHandler?.reloadData()
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
    
    internal var currency: Currency? {
        
        return self.paymentSettings.currency
    }
    
    internal var customer: Customer? {
        
        return self.paymentSettings.customer?.customer
    }
    
    internal var amount: Decimal {
        
        return self.plainAmount ?? 0
    }
    
    internal var items: [PaymentItem]? {

        return self.selectedPaymentItems
    }
    
    internal var mode: TransactionMode {
        
        return self.paymentSettings.transactionMode
    }
    
    internal var taxes: [Tax]? {

        return self.paymentSettings.taxes
    }
    
    internal var shipping: [Shipping]? {

        return self.paymentSettings.shippingList
    }
    
    internal var require3DSecure: Bool {
        
        return true
    }
    
    internal var receiptSettings: Receipt? {
        
        return Receipt(email: true, sms: true)
    }
    
    internal var authorizeAction: AuthorizeAction {
        
        return .capture(after: 8)
    }
}

// MARK: - PaymentDelegate
extension ExampleViewController: PaymentDelegate {
    
    internal func paymentSucceed(_ charge: Charge, payButton: PayButtonProtocol) {
        
        // payment succeed, saving the customer for reuse.
        
        if let customerID = charge.customer.identifier {
            
            self.saveCustomer(customerID)
        }
    }
    
    internal func authorizationSucceed(_ authorize: Authorize, payButton: PayButtonProtocol) {
        
        // authorization succeed, saving the customer for reuse.
        
        if let customerID = authorize.customer.identifier {
            
            self.saveCustomer(customerID)
        }
    }
    
    internal func paymentFailed(with charge: Charge?, error: TapSDKError?, payButton: PayButtonProtocol) {
        
        // payment failed, payment screen closed.
    }
    
    internal func authorizationFailed(with authorization: Authorize?, error: TapSDKError?, payButton: PayButtonProtocol) {
        
        // authorization failed, payment screen closed.
    }
    
    internal func paymentCancelled(_ payButton: PayButtonProtocol) {
        
        // payment cancelled (user manually closed the payment screen).
    }
    
    private func saveCustomer(_ customerID: String) {
        
        if let nonnullCustomer = self.customer {
            
            let envCustomer = SerializationHelper.updateCustomer(nonnullCustomer, with: customerID)
            
            self.paymentSettings.customer = envCustomer
            Serializer.serialize(self.paymentSettings)
        }
    }
}
