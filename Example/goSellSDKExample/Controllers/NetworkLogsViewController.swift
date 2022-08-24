//
//  NetworkLogsViewController.swift
//  goSellSDKExample
//
//  Created by Osama Rabie on 24/08/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import UIKit

class NetworkLogsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        textView.text = UIPasteboard.general.string ?? ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
