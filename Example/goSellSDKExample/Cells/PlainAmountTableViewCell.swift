//
//  PlainAmountTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   Foundation.NSDecimal.Decimal
import struct   Foundation.NSRange.NSRange
import class    Foundation.NSScanner.Scanner
import struct   TapAdditionsKit.UIResponderAdditions
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UITextField.UITextField
import protocol UIKit.UITextField.UITextFieldDelegate

internal protocol PlainAmountTableViewCellTextChangeListener {
    
    func textChanged(_ text: String)
}

internal final class PlainAmountTableViewCell: SelectableCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var textChangeListener: PlainAmountTableViewCellTextChangeListener?
    
    // MARK: Methods
    
    internal func setAmountText(_ amountText: String, changeListener: PlainAmountTableViewCellTextChangeListener) {
        
        self.amountTextField?.text = amountText
        self.textChangeListener = changeListener
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        self.amountTextField?.isUserInteractionEnabled = selected
    }
    
    // MARK: - Private -
    // MARK: Properties
    
	@IBOutlet private weak var amountTextField: UITextField?
    
    // MARK: Methods
    
    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {
        
        UIResponder.resign()
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        
        self.textChangeListener?.textChanged(self.amountTextField?.text ?? .empty)
    }
}

// MARK: - UITextFieldDelegate
extension PlainAmountTableViewCell: UITextFieldDelegate {
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let desiredString = textField.text?.replacing(range: range, withString: string) ?? .empty
        
        if desiredString.length > 0 {
            
            let scanner = Scanner(string: desiredString)
            let isDecimal = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            return isDecimal
        }
        else {
            
            return true
        }
    }
}
