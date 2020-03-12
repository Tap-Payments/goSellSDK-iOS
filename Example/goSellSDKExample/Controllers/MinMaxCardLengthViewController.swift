//
//  DestinationViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct    Foundation.NSIndexPath.IndexPath
import struct    Foundation.NSNotification.Notification
import     goSellSDK
import class    UIKit.UILabel.UILabel
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UITextField.UITextField
import class    UIKit.UITextView.UITextView

internal final class MinMaxCardLengthViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
   internal weak var delegate: MinMaxCardLengthViewControllerDelegate?
    
    
    var currentMin:Int = 0
    var currentMax:Int = 0
    
    internal override var isDoneButtonEnabled: Bool {
        
        return true
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addInputFieldTextChangeObserver()
        self.updateTitle()
        //self.minimumTextField?.text = "\(self.currentMin)"
        self.maximumTextField?.text = "\(self.currentMax)"
    }
    
    internal override func doneButtonClicked() {
        
        //self.dismiss(animated: true, completion: nil)
        if let nonNulldelegate = self.delegate
        {
            nonNulldelegate.minMaxCardLengthViewControllerViewController(self, didFinishWith: 0, max: Int(self.maximumTextField?.text ?? "0") ?? 0)
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
       
    }
    
    deinit {
        
        self.removeInputFieldTextChangeObserver()
    }
    
   
    // MARK: Properties
    
   // @IBOutlet private weak var minimumTextField: UITextField?
    @IBOutlet private weak var maximumTextField: UITextField?
    
 
    // MARK: Methods
    
    private func updateTitle() {
        
        self.title = "Card Number Max Length"
        
    }
  
}

// MARK: - InputFieldObserver
extension MinMaxCardLengthViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateDoneButtonState()
    }
}


// MARK: - SeguePresenter
extension MinMaxCardLengthViewController: SeguePresenter {}
