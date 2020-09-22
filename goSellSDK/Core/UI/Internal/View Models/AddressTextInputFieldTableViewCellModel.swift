//
//  AddressTextInputFieldTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UITextField.UITextField
import protocol UIKit.UITextField.UITextFieldDelegate

/// View model to manager text input address field cell.
internal class AddressTextInputFieldTableViewCellModel: AddressFieldTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: AddressTextInputFieldTableViewCell?
    
    internal var textFieldText: String? {
        
        return self.dataStorage?.cardInputData(for: self.addressField) as? String
    }
    
    private weak var textField: UITextField? {
        
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
    
    internal init(indexPath: IndexPath, addressField: BillingAddressField, specification: AddressField, inputListener: CardAddressInputListener, dataStorage: CardAddressDataStorage, dataManager: AddressFieldsDataManager) {
    
        super.init(indexPath: indexPath, addressField: addressField, specification: specification, inputListener: inputListener, dataStorage: dataStorage)
        self.dataManager = dataManager
    }
    
    internal func bind(with inputField: UITextField) {
        
        self.textField = inputField
        
        let delegate = TextFieldDelegate(model: self)
        self.textFieldDelegate = delegate
        
        self.textField?.delegate = delegate
        
        self.textField?.tap_manualToolbarPreviousButtonHandler = {
            
            self.dataManager?.makePreviousModelFirstResponder(for: self)
        }
        
        self.textField?.tap_manualToolbarNextButtonHandler = {
            
            self.dataManager?.makeNextModelFirstResponder(for: self)
        }
    }
    
    internal func unbindFromInputField() {
        
        self.textField = nil
    }
    
    // MARK: - Fileprivate -
    
    fileprivate class TextFieldDelegate: NSObject {
        
        fileprivate init(model: AddressTextInputFieldTableViewCellModel) {
            
            self.model = model
        }
        
        private unowned let model: AddressTextInputFieldTableViewCellModel
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private weak var dataManager: AddressFieldsDataManager?
    
    private var textFieldDelegate: TextFieldDelegate?
    
    // MARK: Methods
    
    private func addTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged(_:)), name: .tap_textDidChangeNotificationName, object: nil)
    }
    
    private func removeTextChangeObserver() {
        
        NotificationCenter.default.removeObserver(self, name: .tap_textDidChangeNotificationName, object: nil)
    }
    
    @objc private func textFieldTextChanged(_ notification: Notification) {
        
        guard let field = notification.object as? UITextField, field.isEditing, field === self.textField else { return }
        
        self.inputListener?.inputChanged(in: self.addressField, to: self.textField?.text)
    }
}

// MARK: - SingleCellModel
extension AddressTextInputFieldTableViewCellModel: SingleCellModel {}

// MARK: - UITextFieldDelegate
extension AddressTextInputFieldTableViewCellModel.TextFieldDelegate: UITextFieldDelegate {
    
    fileprivate func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            
            self.model.dataManager?.makeNextModelFirstResponder(for: self.model)
        }
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}
