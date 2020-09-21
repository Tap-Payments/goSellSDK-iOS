//
//  ShippingViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import class    goSellSDK.Shipping
import class    UIKit.UITextField.UITextField
import class    UIKit.UITextView.UITextView

internal class ShippingViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: ShippingViewControllerDelegate?
    
    internal var shipping: Shipping? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullShipping = self.shipping {
                
                self.currentShipping = nonnullShipping.copy() as! Shipping
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        return !self.currentShipping.name.isEmpty && self.currentShipping.amount > 0.0
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addInputFieldTextChangeObserver()
        self.updateTitle()
        self.updateWithCurrentShippingInfo()
    }
    
    internal override func doneButtonClicked() {
        
        self.delegate?.shippingViewController(self, didFinishWith: self.currentShipping)
    }
    
    deinit {
        
        self.removeInputFieldTextChangeObserver()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextField: UITextField?
    @IBOutlet private weak var descriptionTextView: UITextView?
    @IBOutlet private weak var amountTextField: UITextField?
    
    private var currentShipping: Shipping = Shipping(name: "", amount: 0.0) {
        
        didSet {
            
            self.updateWithCurrentShippingInfo()
        }
    }
    
    // MARK: Methods
    
    private func updateTitle() {
        
        if self.shipping == nil {
            
            self.title = "Add Shipping"
        }
        else {
            
            self.title = "Edit Shipping"
        }
    }
    
    private func updateCurrentShippingInfoFromInputFields() {
        
        if let shippingTitle = self.titleTextField?.text, !shippingTitle.isEmpty {
            
            self.currentShipping.name = shippingTitle
        }
        else {
            
            self.currentShipping.name = ""
        }
        
        self.currentShipping.descriptionText = self.descriptionTextView?.text
        
        if let amount = self.amountTextField?.text?.tap_decimalValue, amount > 0.0 {
            
            self.currentShipping.amount = amount
        }
        else {
            
            self.currentShipping.amount = 0.0
        }
    }
    
    private func updateWithCurrentShippingInfo() {
        
        self.titleTextField?.text = self.currentShipping.name
        self.descriptionTextView?.text = self.currentShipping.descriptionText
        self.amountTextField?.text = "\(self.currentShipping.amount)"
    }
}

// MARK: - InputFieldObserver
extension ShippingViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentShippingInfoFromInputFields()
        self.updateDoneButtonState()
    }
}
