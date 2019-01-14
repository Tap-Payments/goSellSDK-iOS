//
//  CustomerViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
    
    internal var customer: EnvironmentCustomer? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullCustomer = self.customer {
                
                self.currentCustomer = nonnullCustomer.copy() as! EnvironmentCustomer
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        let cust = self.currentCustomer.customer
        
        if !(cust.identifier?.isEmpty ?? true) { return true }
        
        if cust.firstName?.isEmpty ?? true { return false }
        if cust.emailAddress == nil { return false }
        if cust.phoneNumber == nil { return false }
        
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
    
    private var currentCustomer: EnvironmentCustomer = CustomerViewController.createEmptyCustomer() {
        
        didSet {
            
            self.updateWithCurrentCustomerInfo()
        }
    }
    
    private static func createEmptyCustomer() -> EnvironmentCustomer {
        
        let customer = try! Customer(identifier: "new")
        customer.identifier = nil
        
        let envCustomer = EnvironmentCustomer(customer: customer, environment: .sandbox)
        
        return envCustomer
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
        
        
        
        self.currentCustomer.customer.firstName      = self.firstNameTextField?.text
        self.currentCustomer.customer.middleName     = self.middleNameTextField?.text
        self.currentCustomer.customer.lastName       = self.lastNameTextField?.text
        self.currentCustomer.customer.emailAddress   = try? EmailAddress(emailAddressString: self.emailAddressTextField?.text ?? "")
        self.currentCustomer.customer.phoneNumber    = try? PhoneNumber(isdNumber:   self.phoneISDNumberTextField?.text ?? "",
                                                                        phoneNumber: self.phoneNumberTextField?.text ?? "")
    }
    
    private func updateWithCurrentCustomerInfo() {
        
        self.idLabel?.text                  = self.currentCustomer.customer.identifier
        self.firstNameTextField?.text       = self.currentCustomer.customer.firstName
        self.middleNameTextField?.text      = self.currentCustomer.customer.middleName
        self.lastNameTextField?.text        = self.currentCustomer.customer.lastName
        self.emailAddressTextField?.text    = self.currentCustomer.customer.emailAddress?.value
        self.phoneISDNumberTextField?.text  = self.currentCustomer.customer.phoneNumber?.isdNumber
        self.phoneNumberTextField?.text     = self.currentCustomer.customer.phoneNumber?.phoneNumber
    }
}

// MARK: - InputFieldObserver
extension CustomerViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentCustomerInfoFromInputFields()
        self.updateDoneButtonState()
    }
}
