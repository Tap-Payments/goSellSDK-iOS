//
//  TaxViewController.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/25/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class Foundation.NSNotification.NotificationCenter
import struct Foundation.NSNotification.Notification
import class goSellSDK.AmountModificator
import enum goSellSDK.AmountModificatorType
import class goSellSDK.Tax
import class UIKit.UILabel.UILabel
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UITableViewController.UITableViewController
import class UIKit.UITextField.UITextField
import class UIKit.UITextView.UITextView

internal class TaxViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: TaxViewControllerDelegate?
    
    internal var tax: Tax? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullTax = self.tax {
                
                self.currentTax = nonnullTax.copy() as! Tax
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        return !self.currentTax.title.isEmpty && self.currentTax.amount.value > 0.0
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addInputFieldTextChangeObserver()
        self.updateTitle()
        self.updateWithCurrentTaxInfo()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let caseSelectionController = segue.destination as? CaseSelectionTableViewController {
            
            caseSelectionController.delegate = self
            caseSelectionController.allValues = AmountModificatorType.all
            caseSelectionController.preselectedValue = self.currentTax.amount.type
            
            caseSelectionController.title = "Tax Type"
        }
    }
    
    internal override func doneButtonClicked() {
        
        self.delegate?.taxViewController(self, didFinishWith: self.currentTax)
    }
    
    deinit {
        
        self.removeInputFieldTextChangeObserver()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextField: UITextField?
    @IBOutlet private weak var descriptionTextView: UITextView?
    @IBOutlet private weak var amountTypeLabel: UILabel?
    @IBOutlet private weak var valueTextField: UITextField?
    
    private var currentTax: Tax = Tax(title: "", amount: AmountModificator(type: .percentBased, value: 0.0)) {
        
        didSet {
            
            self.updateWithCurrentTaxInfo()
        }
    }
    
    private var textChanged = false
    
    // MARK: Methods
    
    private func updateTitle() {
        
        if self.tax == nil {
            
            self.title = "Add Tax"
        }
        else {
            
            self.title = "Edit Tax"
        }
    }
    
    private func updateCurrentTaxInfoFromInputFields() {
        
        if let taxTitle = self.titleTextField?.text, !taxTitle.isEmpty {
            
            self.currentTax.title = taxTitle
        }
        else {
            
            self.currentTax.title = ""
        }
        
        self.currentTax.descriptionText = self.descriptionTextView?.text
        
        if let amount = self.valueTextField?.text?.decimalValue, amount > 0.0 {
            
            self.currentTax.amount.value = amount
        }
        else {
            
            self.currentTax.amount.value = 0.0
        }
    }
    
    private func updateWithCurrentTaxInfo() {
        
        self.titleTextField?.text = self.currentTax.title
        self.descriptionTextView?.text = self.currentTax.descriptionText
        self.amountTypeLabel?.text = self.currentTax.amount.type.description
        self.valueTextField?.text = "\(self.currentTax.amount.value)"
    }
    
    private func addInputFieldTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputFieldTextChanged(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    private func removeInputFieldTextChangeObserver() {
        
        NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: nil)
    }
    
    @objc private func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentTaxInfoFromInputFields()
        self.updateDoneButtonState()
    }
}

// MARK: - CaseSelectionTableViewControllerDelegate
extension TaxViewController: CaseSelectionTableViewControllerDelegate {
    
    internal func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value) {
        
        guard let taxType = value as? AmountModificatorType else { return }
        self.currentTax.amount.type = taxType
        self.updateWithCurrentTaxInfo()
    }
}
