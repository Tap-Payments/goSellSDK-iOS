//
//  ViewController.swift
//  GoSellAppClip
//
//  Created by Osama Rabie on 11/20/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
//import goSellSDK

class ViewController: UIViewController {

    var transactionAmount:Double = 100
  //  var session:Session = .init()
    @IBOutlet weak var amoountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    /*    GoSellSDK.secretKey = SecretKey(sandbox:    "YOUR_SANDBOX_SECRET_KEY",
                                        production:    "YOUR_PRODUCTION_SECRET_KEY")
        GoSellSDK.mode = .sandbox
        GoSellSDK.language = "en"
        
        session.dataSource = self*/
        
    }

    @IBAction func payInMainApp(_ sender: Any) {
    }
    @IBAction func payInAppClip(_ sender: Any) {
        //session.start()
    }
}


/*extension ViewController:SessionDataSource {
    var customer: Customer? {
        return try! .init(emailAddress: nil, phoneNumber: .init(isdNumber: "965", phoneNumber: "90064542") , firstName: "Tap", middleName: "Payments", lastName: "Clips")
    }
    
    
    internal var applePayMerchantID: String
    {
        return "merchant.tap.gosell"
    }
    
    internal var merchantID: String?
    {
        return "1124340"
    }
    
    internal var mode: TransactionMode {
        
        return .purchase
    }
    
    var currency: Currency? {
        return try! .init(isoCode: "KWD")
    }
    
    var amount: Decimal{
        return .init(Double(amoountTextField.text ?? "100") ?? transactionAmount)
    }
}
*/
