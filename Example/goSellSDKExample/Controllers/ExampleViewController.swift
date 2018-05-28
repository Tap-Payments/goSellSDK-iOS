//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class goSellSDK.Currency
import class goSellSDK.CustomerInfo
import class goSellSDK.EmailAddress
import class goSellSDK.PayButton
import protocol goSellSDK.PaymentDataSource
import class goSellSDK.PaymentItem
import class UIKit.UINavigationController.UINavigationController
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UITableView.UITableView
import class UIKit.UIViewController.UIViewController

internal class ExampleViewController: UIViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var paymentItems: [PaymentItem] = Serializer.deserializeItems()
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "goSell SDK Example"
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let paymentController = (segue.destination as? UINavigationController)?.rootViewController as? PaymentItemViewController {
            
            paymentController.delegate = self
            paymentController.paymentItem = self.selectedPaymentItem
        }
    }
    
    internal func showPaymentItemViewController(with item: PaymentItem? = nil) {
        
        self.selectedPaymentItem = item
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(PaymentItemViewController.className)Segue", sender: self)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var itemsTableView: UITableView?
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

// MARK: - PaymentDataSource
extension ExampleViewController: PaymentDataSource {
    
    internal var customer: CustomerInfo {
        
        return try! CustomerInfo(emailAddress:  EmailAddress("tap_customer@tap.company"),
                                 phoneNumber:   "+96500000000",
                                 firstName:     "Tap",
                                 lastName:      "Customer")
    }
    
    internal var items: [PaymentItem] {
        
        return self.paymentItems
    }
    
    internal var currency: Currency {
        
        return try! Currency(isoCode: "KWD")
    }
}
