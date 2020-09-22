//
//  ExpirationDateValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func     TapAdditionsKitV2.tap_clamp
import protocol TapAdditionsKitV2.ClassProtocol
import struct	TapBundleLocalization.LocalizationKey
import class    TapEditableViewV2.TapEditableView
import protocol TapEditableViewV2.TapEditableViewDelegate
import class	UIKit.UIPickerView.UIPickerView
import protocol	UIKit.UIPickerView.UIPickerViewDataSource
import protocol	UIKit.UIPickerView.UIPickerViewDelegate
import class	UIKit.UITextField.UITextField

/// Expiration Date Validator class.
internal class ExpirationDateValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Expiration date.
    internal private(set) var expirationDate: ExpirationDate? {
        
        didSet {
            
            self.delegate?.cardValidator(self, inputDataChanged: self.expirationDate)
        }
    }
    
    internal override var isValid: Bool {
        
        guard let nonnullExpirationDate = self.expirationDate else { return false }
        
        let currentDate = Date()
        let month = currentDate.tap_month
        let year = currentDate.tap_year % 100
		
		let dateYear = nonnullExpirationDate.year % 100
		
        if year < dateYear {
            
            return true
        }
        else if year == dateYear {
            
            return month <= nonnullExpirationDate.month
        }
        else {
            
            return false
        }
    }
	
	internal override var errorCode: ErrorCode? {
		
		return self.isValid ? nil : .invalidExpirationDate
	}
    
    // MARK: Methods
    
    internal init(editableView: TapEditableView, textField: UITextField) {
        
        self.editableView = editableView
        self.textField = textField
        
        super.init(validationType: .expirationDate)
        
        self.setupEditableView()
    }
    
    internal override func update(with inputData: Any?) {
        
        if let date = inputData as? ExpirationDate {
            
            self.expirationDate = date
        }
        else {
            
            self.expirationDate = nil
        }
        
        self.updateTextFieldText(shouldClear: inputData == nil)
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
        let year = ExpirationDatePickerHandler.currentYear + picker.selectedRow(inComponent: ExpirationDatePickerHandler.DatePickerComponent.year.rawValue)
        
        self.expirationDate = ExpirationDate(month: month, year: year)
        
        self.updateTextFieldText(shouldClear: false)
    }
    
    private func inputFieldDidBeginEditing() {
        
        self.updatePickerViewSelection(animated: false)
        self.updateTextFieldText(shouldClear: false)
    }
    
    private func inputFieldDidEndEditing() {
        
        let textSettings = Theme.current.paymentOptionsCellStyle.card.textInput
        
		let attributes = textSettings[self.isDataValid ? .valid : .invalid]
        self.updateTextFieldText(shouldClear: false, attributes: attributes.asStringAttributes)
    }
    
    private func updateTextFieldText(shouldClear: Bool, attributes: [NSAttributedString.Key: Any]? = nil) {
        
        if shouldClear {
            
            self.textField.attributedText = nil
        }
        else {
            
            guard let date = self.expirationDate else {
                
                self.textField.attributedText = nil
                return
            }
            
            let stringAttributes = attributes ?? Theme.current.paymentOptionsCellStyle.card.textInput[.valid].asStringAttributes
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
        
        let minimalMonthIndex = 0
        let minimalYearIndex = 0
        let maximalMonthIndex = picker.numberOfRows(inComponent: ExpirationDatePickerHandler.DatePickerComponent.month.rawValue) - 1
        let maximalYearIndex = picker.numberOfRows(inComponent: ExpirationDatePickerHandler.DatePickerComponent.year.rawValue) - 1
        
        let monthIndex  = tap_clamp(value: minimalMonthIndex,   low: nonnullExpirationDate.month - 1,                                       high: maximalMonthIndex)
        let yearIndex   = tap_clamp(value: minimalYearIndex,    low: nonnullExpirationDate.year - ExpirationDatePickerHandler.currentYear,  high: maximalYearIndex)
        
        picker.selectRow(monthIndex, inComponent: ExpirationDatePickerHandler.DatePickerComponent.month.rawValue, animated: animated)
        picker.selectRow(yearIndex, inComponent: ExpirationDatePickerHandler.DatePickerComponent.year.rawValue, animated: animated)
    }
}

// MARK: - TapEditableViewDelegate
extension ExpirationDateValidator: TapEditableViewDelegate {
    
    internal func editableViewDidBeginEditing(_ editableView: TapEditableView) {
        
        if #available(iOS 9.0, *) {
            
            editableView.inputView?.tap_applySemanticContentAttribute(.forceLeftToRight)
        }
        
        self.inputFieldDidBeginEditing()
        self.validate()
    }
    
    internal func editableViewDidEndEditing(_ editableView: TapEditableView) {
        
        self.inputFieldDidEndEditing()
        self.validate()
    }
}

// MARK: - TextFieldInputDataValidation
extension ExpirationDateValidator: TextFieldInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.expirationDate?.inputFieldRepresentation ?? .tap_empty
    }
    
    internal var textInputFieldPlaceholderText: LocalizationKey {
        
        return .card_input_expiration_date_placeholder
    }
    
    internal func updateSpecificInputFieldAttributes() { }
}

// MARK: - ExpirationDatePickerHandler
fileprivate extension ExpirationDateValidator {
    
    class ExpirationDatePickerHandler: NSObject {
        
        fileprivate init(validator: ExpirationDateValidator) {
            
            self.validator = validator
            super.init()
        }
        
        private unowned let validator: ExpirationDateValidator
        
        fileprivate enum DatePickerComponent: Int {
            
            case month = 0, year
            
            fileprivate var numberOfRows: Int {
                
                switch self {
                    
                case .month:    return Constants.numberOfMonthsInPickerView
                case .year:     return Constants.numberOfYearsInPickerView

                }
            }
            
            fileprivate var componentWidth: CGFloat {
                
                switch self {
                    
                case .month:    return Constants.monthComponentWidth
                case .year:     return Constants.yearComponentWidth

                }
            }
            
            fileprivate func text(for row: Int) -> String {
                
                let formatter = type(of: self).numberFormatter
                var argument: Int
                
                switch self {
                    
                case .month:
                    
                    formatter.minimumIntegerDigits = 2
                    argument = row + 1
                    
                case .year:
                    
                    formatter.minimumIntegerDigits = 4
                    argument = ExpirationDatePickerHandler.currentYear + row
                }
                
                return formatter.string(from: NSNumber(value: argument))!
            }
            
            private static let numberFormatter: NumberFormatter  = {
               
                let formatter = NumberFormatter(locale: .tap_enUS)
                formatter.groupingSeparator = ""
                formatter.numberStyle = .decimal
                
                return formatter
                
            }()
        }
        
        private struct Constants {
            
            fileprivate static let numberOfComponentsInPickerView:  Int     = 2
            fileprivate static let numberOfMonthsInPickerView:      Int     = 12
            fileprivate static let numberOfYearsInPickerView:       Int     = 51
            fileprivate static let monthComponentWidth:             CGFloat = 50.0
            fileprivate static let yearComponentWidth:              CGFloat = 100.0
            
            //@available(*, unavailable) private init() { }
        }
        
        fileprivate static var currentYear: Int = Date().tap_year
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
        
        return DatePickerComponent(rawValue: component)!.componentWidth
    }
    
    fileprivate func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.validator.updateExpirationDate(from: pickerView)
    }
    
    fileprivate func title(for row: Int, forComponent component: DatePickerComponent) -> String? {
        
        return component.text(for: row)
    }
}
