//
//  SetupApplePayViewController.swift
//  goSellSDK
//
//  Created by Osama Rabie on 09/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import class PassKit.PKPaymentButton
import enum PassKit.PKPaymentButtonType

class SetupApplePayViewController: UIViewController {

	
    @IBOutlet weak var applePayButtonContentView: UIView!
    internal weak var delegate: SetupApplePayViewControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func cancelButtonClicked(_ sender: Any) {
		if let delegate = self.delegate
		{
			delegate.setupApplePayViewControllerDidCancel(self)
		}else
        {
            self.dismiss(animated: true, completion: nil)
        }
	}
    
	@IBAction func setupApplePayClicked(_ sender: Any) {
		if let delegate = self.delegate
        {
            delegate.setupApplePayViewControllerSetpButtonTouchUpInside(self)
        }else
        {
            self.dismiss(animated: true, completion: nil)
        }
	}
}


// MARK: - InstantiatableFromStoryboard
extension SetupApplePayViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPayment
    }
}
