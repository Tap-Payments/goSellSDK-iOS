//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class goSellSDK.Currency
import class goSellSDK.Customer
import class goSellSDK.EmailAddress
import class goSellSDK.PayButton
import protocol goSellSDK.PayButtonDelegate
import class goSellSDK.PaymentContainerViewController
import protocol goSellSDK.PaymentDataSource
import class goSellSDK.PaymentItem
import class UIKit.UIViewController.UIViewController

internal class ExampleViewController: UIViewController {
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var payButton: PayButton?
}

extension ExampleViewController: PaymentDataSource {
    
    internal var customer: Customer {
        
        return try! Customer(emailAddress: EmailAddress("tap_customer@tap.company"),
                             phoneNumber: "+96500000000",
                             firstName: "Tap",
                             lastName: "Customer")
    }
    
    internal var items: [PaymentItem] {
        
        let item1 = PaymentItem(title: "Zain 5.000", quantity: 2, unitsOfMeasurement: .units, amountPerUnit: 5.0)
        let item2 = PaymentItem(title: "Ooredoo 10.000", description: "Ooredoo topup", quantity: 1, unitsOfMeasurement: .units, amountPerUnit: 10.0)

        return [item1, item2]
    }
    
    internal var currency: Currency {
        
        return try! Currency(isoCode: "KWD")
    }
}

extension ExampleViewController: PayButtonDelegate {
    
    internal func showPaymentController(_ controller: PaymentContainerViewController) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.present(controller, animated: false)
        }
    }
}
