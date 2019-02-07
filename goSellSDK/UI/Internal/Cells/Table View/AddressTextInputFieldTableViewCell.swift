//
//  AddressTextInputFieldTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIResponder.UIResponder
import class UIKit.UITextField.UITextField

internal class AddressTextInputFieldTableViewCell: AddressFieldTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: AddressTextInputFieldTableViewCellModel?
	
	internal private(set) var isContentBinded: Bool = false
	
    internal var inputField: UITextField? {
        
        return self.inputTextField
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var inputTextField: UITextField?
}

// MARK: - LoadingWithModelCell
extension AddressTextInputFieldTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.updateDescription(self.model?.descriptionText, width: self.model?.descriptionWidth ?? 0.0)
        self.inputTextField?.text = self.model?.textFieldText
        self.updateTextFieldKeyboard()
    }
    
    private func updateTextFieldKeyboard() {
        
        self.inputTextField?.keyboardAppearance = Theme.current.commonStyle.keyboardAppearance.uiKeyboardAppearance
        
        guard let nonnullModel = self.model else { return }
        
        switch nonnullModel.fieldSpecification.type {
            
        case .textInput(let type):
            
            switch type {
                
            case .digits:
                
                if #available(iOS 10.0, *) {
                    
                    self.inputTextField?.keyboardType = .asciiCapableNumberPad
                    
                } else {
                    
                    self.inputTextField?.keyboardType = .numberPad
                }
                
            case .text:
                
                self.inputTextField?.keyboardType = .default
                
            }
            
        default:
            
            break
        }
    }
}

// MARK: - BindingWithModelCell
extension AddressTextInputFieldTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        if let textField = self.inputTextField {
            
            self.model?.bind(with: textField)
        }
		
		self.isContentBinded = true
    }
    
    internal func unbindContent() {
        
        self.model?.unbindFromInputField()
		
		self.isContentBinded = false
    }
}
