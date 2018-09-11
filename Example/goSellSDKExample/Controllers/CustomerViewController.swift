//
//  CustomerViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   Foundation.NSNotification.Notification
import class    goSellSDK.Customer
import class    goSellSDK.EmailAddress
import class    goSellSDK.PhoneNumber
import class    UIKit.UILabel.UILabel
import class    UIKit.UITextField.UITextField
import class    UIKit.UIView.UIView

internal class CustomerViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CustomerViewControllerDelegate?
    
    internal var customer: Customer? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullCustomer = self.customer {
                
                self.currentCustomer = nonnullCustomer.copy() as! Customer
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        if !(self.currentCustomer.identifier?.isEmpty ?? true) { return true }
        
        if self.currentCustomer.firstName?.isEmpty ?? true { return false }
        if self.currentCustomer.emailAddress == nil { return false }
        if self.currentCustomer.phoneNumber == nil { return false }
        
        return true
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addInputFieldTextChangeObserver()
        self.updateTitle()
        self.updateWithCurrentCustomerInfo()
        
        self.tableView.tableFooterView = UIView()
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
    @IBOutlet private weak var middleNameTextField: UITextField?
    @IBOutlet private weak var lastNameTextField: UITextField?
    @IBOutlet private weak var emailAddressTextField: UITextField?
    @IBOutlet private weak var phoneISDNumberTextField: UITextField?
    @IBOutlet private weak var phoneNumberTextField: UITextField?
    
    private var currentCustomer: Customer = try! Customer(identifier: "") {
        
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
        
        self.currentCustomer.firstName      = self.firstNameTextField?.text
        self.currentCustomer.middleName     = self.middleNameTextField?.text
        self.currentCustomer.lastName       = self.lastNameTextField?.text
        self.currentCustomer.emailAddress   = try? EmailAddress(emailAddressString: self.emailAddressTextField?.text ?? "")
        self.currentCustomer.phoneNumber    = try? PhoneNumber(isdNumber:   self.phoneISDNumberTextField?.text ?? "",
                                                               phoneNumber: self.phoneNumberTextField?.text ?? "")
    }
    
    private func updateWithCurrentCustomerInfo() {
        
        self.idLabel?.text                  = self.currentCustomer.identifier
        self.firstNameTextField?.text       = self.currentCustomer.firstName
        self.middleNameTextField?.text      = self.currentCustomer.middleName
        self.lastNameTextField?.text        = self.currentCustomer.lastName
        self.emailAddressTextField?.text    = self.currentCustomer.emailAddress?.value
        self.phoneISDNumberTextField?.text  = self.currentCustomer.phoneNumber?.isdNumber
        self.phoneNumberTextField?.text     = self.currentCustomer.phoneNumber?.phoneNumber
    }
}

// MARK: - InputFieldObserver
extension CustomerViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentCustomerInfoFromInputFields()
        self.updateDoneButtonState()
    }
}
