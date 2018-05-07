//
//  ExpirationDateValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import TapResponderChainInputView

import protocol TapAdditionsKit.ClassProtocol
import class TapEditableView.TapEditableView
import protocol TapEditableView.TapEditableViewDelegate

/// Expiration Date Validator class.
internal class ExpirationDateValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Expiration date.
    internal private(set) var expirationDate: ExpirationDate?
    
    internal override var isValid: Bool {
        
        guard let nonnullExpirationDate = self.expirationDate else { return false }
        
        let currentDate = Date()
        let month = currentDate.month
        let year = currentDate.year % 100
        
        if year < nonnullExpirationDate.year {
            
            return true
        }
        else if year == nonnullExpirationDate.year {
            
            return month <= nonnullExpirationDate.month
        }
        else {
            
            return false
        }
    }
    
    // MARK: Methods
    
    internal init(editableView: TapEditableView, textField: UITextField) {
        
        self.editableView = editableView
        self.textField = textField
        
        super.init(validationType: .expirationDate)
        
        self.setupEditableView()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned let editableView: TapEditableView
    private unowned let textField: UITextField
    
    private lazy var pickerViewHandler: ExpirationDatePickerHandler = ExpirationDatePickerHandler(validator: self)
    
    // MARK: Methods
    
    private func setupEditableView() {
        
        self.editableView.delegate = self
        
        let datePicker = UIPickerView()
        datePicker.dataSource = self.pickerViewHandler
        datePicker.delegate = self.pickerViewHandler
        datePicker.showsSelectionIndicator = true
        
        self.editableView.inputView = datePicker
    }
    
    private func updateExpirationDate(from picker: UIPickerView) {
        
        let month = picker.selectedRow(inComponent: ExpirationDatePickerHandler.DatePickerComponent.month.rawValue) + 1
        let year = picker.selectedRow(inComponent: ExpirationDatePickerHandler.DatePickerComponent.year.rawValue)
        
        self.expirationDate = ExpirationDate(month: month, year: year)
        
        self.updateTextFieldText(shouldClear: false)
    }
    
    private func inputFieldDidBeginEditing() {
        
        self.updatePickerViewSelection(animated: false)
        self.updateTextFieldText(shouldClear: false)
    }
    
    private func inputFieldDidEndEditing() {
        
        let textSettings = Theme.current.settings.cardInputFieldsSettings
        
        let attributes = self.isDataValid ? textSettings.valid : textSettings.invalid
        self.updateTextFieldText(shouldClear: false, attributes: attributes.asStringAttributes)
    }
    
    private func updateTextFieldText(shouldClear: Bool, attributes: [NSAttributedStringKey: Any]? = nil) {
        
        if shouldClear {
            
            self.textField.attributedText = nil
        }
        else {
            
            guard let date = self.expirationDate else {
                
                self.textField.attributedText = nil
                return
            }
            
            let stringAttributes = attributes ?? Theme.current.settings.cardInputFieldsSettings.valid.asStringAttributes
            self.textField.attributedText = NSAttributedString(string: date.inputFieldRepresentation, attributes: stringAttributes)
        }
        
        self.validate()
    }
    
    private func updatePickerViewSelection(animated: Bool) {
        
        guard let picker = self.editableView.inputView as? UIPickerView else { return }
        
        if self.expirationDate == nil {
            
            self.expirationDate = .current
        }
        
        guard let nonnullExpirationDate = self.expirationDate else { return }
        
        picker.selectRow(nonnullExpirationDate.month - 1, inComponent: ExpirationDatePickerHandler.DatePickerComponent.month.rawValue, animated: animated)
        picker.selectRow(nonnullExpirationDate.year, inComponent: ExpirationDatePickerHandler.DatePickerComponent.year.rawValue, animated: animated)
    }
}

// MARK: - TapEditableViewDelegate
extension ExpirationDateValidator: TapEditableViewDelegate {
    
    internal func editableViewDidBeginEditing(_ editableView: TapEditableView) {
        
        if #available(iOS 9.0, *) {
            
            editableView.inputView?.applySemanticContentAttribute(.forceLeftToRight)
        }
        
        self.inputFieldDidBeginEditing()
        self.validate()
    }
    
    internal func editableViewDidEndEditing(_ editableView: TapEditableView) {
        
        self.inputFieldDidEndEditing()
        self.validate()
    }
}

// MARK: - TextInputDataValidation
extension ExpirationDateValidator: TextInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.expirationDate?.inputFieldRepresentation ?? .empty
    }
    
    internal var textInputFieldPlaceholderText: String {
        
        return "MM/YY"
    }
    
    internal func updateSpecificInputFieldAttributes() { }
}

// MARK: - ExpirationDatePickerHandler
fileprivate extension ExpirationDateValidator {
    
    fileprivate class ExpirationDatePickerHandler: NSObject {
        
        fileprivate init(validator: ExpirationDateValidator) {
            
            self.validator = validator
            super.init()
        }
        
        private unowned let validator: ExpirationDateValidator
        
        fileprivate enum DatePickerComponent: Int {
            
            case month = 0, year
            
            fileprivate var numberOfRows: Int {
                
                switch self {
                    
                case .month:
                    
                    return Constants.numberOfMonthsInPickerView
                    
                case .year:
                    
                    return Constants.numberOfYearsInPickerView
                }
            }
            
            fileprivate func text(for row: Int) -> String {
                
                let integerText = self == .month ? row + 1 : row
                return String(format: "%02d", locale: Locale.enUS, arguments: [integerText])
            }
        }
        
        private struct Constants {
            
            fileprivate static let numberOfComponentsInPickerView = 2
            fileprivate static let numberOfMonthsInPickerView = 12
            fileprivate static let numberOfYearsInPickerView = 100
            fileprivate static let pickerViewRowHeight: CGFloat = 50.0
            
            @available(*, unavailable) private init() {}
        }
    }
}

// MARK: - UIPickerViewDataSource
extension ExpirationDateValidator.ExpirationDatePickerHandler: UIPickerViewDataSource {
    
    fileprivate func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return Constants.numberOfComponentsInPickerView
    }
    
    fileprivate func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.numberOfRows(in: pickerView, for: DatePickerComponent(rawValue: component)!)
    }
    
    private func numberOfRows(in pickerView: UIPickerView, for component: DatePickerComponent) -> Int {
        
        return component.numberOfRows
    }
}

// MARK: - UIPickerViewDelegate
extension ExpirationDateValidator.ExpirationDatePickerHandler: UIPickerViewDelegate {
    
    fileprivate func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.title(for: row, forComponent: DatePickerComponent(rawValue: component)!)
    }
    
    fileprivate func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return Constants.pickerViewRowHeight
    }
    
    fileprivate func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.validator.updateExpirationDate(from: pickerView)
    }
    
    fileprivate func title(for row: Int, forComponent component: DatePickerComponent) -> String? {
        
        return component.text(for: row)
    }
}
