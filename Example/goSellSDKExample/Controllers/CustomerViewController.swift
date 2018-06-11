//
//  CustomerViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   Foundation.NSNotification.Notification
import class    goSellSDK.CustomerInfo
import class    goSellSDK.EmailAddress
import class    UIKit.UILabel.UILabel
import class    UIKit.UITextField.UITextField

internal class CustomerViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CustomerViewControllerDelegate?
    
    internal var customer: CustomerInfo? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullCustomer = self.customer {
                
                self.currentCustomer = nonnullCustomer.copy() as! CustomerInfo
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        if !(self.currentCustomer.identifier?.isEmpty ?? true) { return true }
        
        if self.currentCustomer.firstName?.isEmpty ?? true { return false }
        if self.currentCustomer.emailAddress == nil { return false }
        if self.currentCustomer.phoneNumber?.isEmpty ?? true { return false }
        
        return true
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addInputFieldTextChangeObserver()
        self.updateTitle()
        self.updateWithCurrentCustomerInfo()
    }
    
    internal override func doneButtonClicked() {
        
        self.delegate?.customerViewController(self, didFinishWith: self.currentCustomer)
    }
    
    deinit {
        
        self.removeInputFieldTextChangeObserver()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var idLabel: UILabel?
    @IBOutlet private weak var firstNameTextField: UITextField?
    @IBOutlet private weak var lastNameTextField: UITextField?
    @IBOutlet private weak var emailAddressTextField: UITextField?
    @IBOutlet private weak var phoneNumberTextField: UITextField?
    
    private var currentCustomer: CustomerInfo = try! CustomerInfo(identifier: "") {
        
        didSet {
            
            self.updateWithCurrentCustomerInfo()
        }
    }
    
    // MARK: Methods
    
    private func updateTitle() {
        
        if self.customer == nil {
            
            self.title = "Add Customer"
        }
        else {
            
            self.title = "Edit Customer"
        }
    }
    
    private func updateCurrentCustomerInfoFromInputFields() {
        
        self.currentCustomer.firstName = self.firstNameTextField?.text
        self.currentCustomer.lastName = self.lastNameTextField?.text
        self.currentCustomer.emailAddress = try? EmailAddress(self.emailAddressTextField?.text ?? "")
        self.currentCustomer.phoneNumber = self.phoneNumberTextField?.text
    }
    
    private func updateWithCurrentCustomerInfo() {
        
        self.idLabel?.text = self.currentCustomer.identifier
        self.firstNameTextField?.text = self.currentCustomer.firstName
        self.lastNameTextField?.text = self.currentCustomer.lastName
        self.emailAddressTextField?.text = self.currentCustomer.emailAddress?.value
        self.phoneNumberTextField?.text = self.currentCustomer.phoneNumber
    }
}

// MARK: - InputFieldObserver
extension CustomerViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentCustomerInfoFromInputFields()
        self.updateDoneButtonState()
    }
}
