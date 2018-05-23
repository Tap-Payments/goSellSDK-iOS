//
//  AddressTextInputFieldTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITextField.UITextField

/// View model to manager text input address field cell.
internal class AddressTextInputFieldTableViewCellModel: AddressFieldTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: AddressTextInputFieldTableViewCell?
    
    internal var textFieldText: String? {
        
        return self.dataStorage?.cardInputData(for: self.addressField) as? String
    }
    
    // MARK: Methods
    
    internal func bind(with inputField: UITextField) {
        
        self.textField = inputField
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    internal weak var textField: UITextField? {
        
        didSet {
            
            if self.textField == nil {
                
                self.removeTextChangeObserver()
            }
            else {
                
                self.addTextChangeObserver()
            }
        }
    }
    
    // MARK: Methods
    
    private func addTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged(_:)), name: .UITextFieldTextDidChange, object: nil)
    }
    
    private func removeTextChangeObserver() {
        
        NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
    }
    
    @objc private func textFieldTextChanged(_ notification: Notification) {
        
        guard let field = notification.object as? UITextField, field === self.textField else { return }
        
        self.inputListener?.inputChanged(in: self.addressField, to: self.textField?.text)
    }
}

// MARK: - SingleCellModel
extension AddressTextInputFieldTableViewCellModel: SingleCellModel {}
