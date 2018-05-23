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
import class UIKit.UIViewController.UIViewController

internal class ExampleViewController: UIViewController {
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var payButton: PayButton?
}

extension ExampleViewController: PaymentDataSource {
    
    internal var customer: CustomerInfo {
        
        return try! CustomerInfo(emailAddress: EmailAddress("tap_customer@tap.company"),
                             phoneNumber: "+96500000000",
                             firstName: "Tap",
                             lastName: "Customer")
    }
    
    internal var items: [PaymentItem] {

//        let item1 = PaymentItem(title: "Zain 5.000", quantity: 2, unitsOfMeasurement: .units, amountPerUnit: 5.0)
//        let item2 = PaymentItem(title: "Ooredoo 10.000", description: "Ooredoo topup", quantity: 1, unitsOfMeasurement: .units, amountPerUnit: 10.0)

        let item1 = PaymentItem(title: "Potato", quantity: 1.5, unitsOfMeasurement: .mass(.kilograms), amountPerUnit: 0.4)
        let item2 = PaymentItem(title: "Onion", quantity: 1.0, unitsOfMeasurement: .mass(.kilograms), amountPerUnit: 0.3)
        
        return [item1, item2]
    }
    
    internal var currency: Currency {
        
        return try! Currency(isoCode: "KWD")
    }
}
