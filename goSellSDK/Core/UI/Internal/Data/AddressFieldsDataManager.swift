//
//  AddressFieldsDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import func     TapSwiftFixesV2.performOnMainThread
import class    UIKit.UIFont.UIFont
import class    UIKit.UITextField.UITextField

/// Data manager to manage address fields.
internal class AddressFieldsDataManager {
    
    // MARK: - Internal -
    
    internal struct Constants {
        
        internal static let countryFieldName = "country"
        
        fileprivate static let countryTopEmptyCellModelIdentifier       = "country_top_empty_cell_model"
        fileprivate static let countryBottomEmptyCellModelIdentifier    = "country_bottom_empty_cell_model"
        
        fileprivate static let descriptionFont: UIFont = .helveticaNeueRegular(15.0)
        fileprivate static let extraDescriptionWidth: CGFloat = 3.0
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    internal weak var loadingListener: AddressFieldsDataManagerLoadingListener?
    
    internal unowned let validator: CardAddressValidator
    
    internal var reloadClosure: TypeAlias.ArgumentlessClosure?
    
    internal private(set) var cellViewModels: [TableViewCellViewModel] = [] {
        
        didSet {
            
            self.calculateRequiredDescriptionWidthAndAssignToModels()
            self.reloadClosure?()
        }
    }
    
    internal var country: Country {
        
        get {
            
            guard let result = self.validator.country else {
                
                fatalError("Should never reach here")
            }
            
            return result
        }
        set {
            
            guard self.country != newValue else { return }
            
            self.countryCellModel.preselectedValue = newValue
            self.validator.country = newValue
            
            self.generateCellViewModels()
        }
    }
    
    // MARK: Methods
    
    internal init(validator: CardAddressValidator, loadingListener: AddressFieldsDataManagerLoadingListener) {
        
        self.validator = validator
        self.loadingListener = loadingListener
        self.generateCellViewModels()
    }
    
    internal func obtainAddressFormat(for country: Country, completion: @escaping (BillingAddressFormat) -> Void) {
        
        self.retrieveAddressFieldsData { (response) in
            
            let format = self.addressFormat(for: country, from: response)
            completion(format)
        }
    }
    
    internal func tableViewWillDisplayCell(connectedTo model: TableViewCellViewModel) {
        
        if let inputFieldModel = model as? AddressTextInputFieldTableViewCellModel {
            
            self.connectInputFieldResponders(for: inputFieldModel)
            
            if inputFieldModel.indexPath == self.indexPathToMakeFirstResponderOnceVisible {
                
                inputFieldModel.cell?.inputField?.becomeFirstResponder()
                self.indexPathToMakeFirstResponderOnceVisible = nil
            }
        }
        
        
    }
    
    internal static func fieldSpecification(for field: BillingAddressField) -> AddressField {
        
        guard let allFieldSpecifications = self.cachedAddressFieldsData?.fields else {
            
            fatalError("Address fields data is not loaded.")
        }
        
        guard let result = allFieldSpecifications.first(where: { $0.name == field.name }) else {
            
            fatalError("There is no field \(field.name) in available address format data.")
        }
        
        return result
    }
    
    internal func makePreviousModelFirstResponder(for model: AddressTextInputFieldTableViewCellModel) {
        
        let index = model.indexPath.row - 1
        guard index > 0 else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        self.makeInputFieldAtIndexPathFirstResponder(indexPath)
    }
    
    internal func makeNextModelFirstResponder(for model: AddressTextInputFieldTableViewCellModel) {
        
        let index = model.indexPath.row + 1
        
        guard index < self.cellViewModels.count else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        self.makeInputFieldAtIndexPathFirstResponder(indexPath)
    }
    
    // MARK: - Private -
    
    private typealias AddressFieldsResponse = (BillingAddressResponse) -> Void
    
    // MARK: Properties
    
    private static var cachedAddressFieldsData: BillingAddressResponse?
    
    private var isLoadingAddressFields: Bool = false
    private var indexPathToMakeFirstResponderOnceVisible: IndexPath?
    
    // MARK: Methods
    
    private func makeInputFieldAtIndexPathFirstResponder(_ indexPath: IndexPath) {
        
        guard let model = self.cellViewModels[indexPath.row] as? AddressTextInputFieldTableViewCellModel else { return }
        if model.tableView?.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            
            model.cell?.inputField?.becomeFirstResponder()
        }
        else {
            
            self.indexPathToMakeFirstResponderOnceVisible = indexPath
            model.tableView?.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    private func connectInputFieldResponders(for model: AddressTextInputFieldTableViewCellModel) {
        
        let modelInputField = model.cell?.inputField
        let previousInputField = self.previousModelInputField(for: model)
        let nextInputField = self.nextModelInputField(for: model)
        
        previousInputField?.tap_nextField = modelInputField
        previousInputField?.returnKeyType = modelInputField == nil ? .done : .next
        
        nextInputField?.tap_previousField = modelInputField
        
        modelInputField?.tap_previousField = previousInputField
        
        modelInputField?.tap_nextField = nextInputField
        modelInputField?.returnKeyType = nextInputField == nil ? .done : .next
    }
    
    private func retrieveAddressFieldsData(_ success: @escaping AddressFieldsResponse) {
        
        if let cachedData = type(of: self).cachedAddressFieldsData {
            
            self.callCompletion(success, with: cachedData)
            return
        }
        
        guard !self.isLoadingAddressFields else { return }
        
        self.loadingListener?.addressFieldsDataManagerDidStartLoadingFormats()
        self.isLoadingAddressFields = true
        
        APIClient.shared.getBillingAddressFormats { (response, error) in
            
            self.isLoadingAddressFields = false
            self.loadingListener?.addressFieldsDataManagerDidStopLoadingFormats()
            
            if let nonnullError = error {
            
                ErrorDataManager.handle(nonnullError, retryAction: { self.retrieveAddressFieldsData(success) }, alertDismissButtonClickHandler: nil)
            }
            else if let nonnullResponse = response {
                
                type(of: self).cachedAddressFieldsData = nonnullResponse
                self.callCompletion(success, with: nonnullResponse)
            }
        } 
    }
    
    private func callCompletion(_ closure: @escaping AddressFieldsResponse, with data: BillingAddressResponse) {
        
        performOnMainThread {
            
            closure(data)
        }
    }
    
    private func addressFormat(for country: Country, from response: BillingAddressResponse) -> BillingAddressFormat {
        
        guard let formatName = response.countryFormats[country] else {
            
            fatalError("We don't have address format for \(country.displayName)")
        }
        
        guard let format = response.formats.first(where: { $0.name == formatName }) else {
            
            fatalError("We don't have address format for \(country.displayName)")
        }
        
        return format
    }
    
    private func generateCellViewModels() {
        
        guard let country = self.validator.country else {
            
            self.cellViewModels = []
            return
        }
        
        self.obtainAddressFormat(for: country) { (format) in
            
            self.validator.selectedAddressFormat = format
            
            var orderedFields = format.fields.sorted { $0.inputOrder < $1.inputOrder }
            
            if !orderedFields.contains(where: { $0.name == Constants.countryFieldName }) {
                
                let countryField = BillingAddressField(name: Constants.countryFieldName, isRequired: true, inputOrder: 0, displayOrder: .max)
                orderedFields.insert(countryField, at: 0)
            }
            
            var result: [TableViewCellViewModel] = []
            
            orderedFields.forEach { (field) in
                
                let fieldSpecification = type(of: self).fieldSpecification(for: field)
                switch fieldSpecification.type {
                    
                case .dropdown:
                    
                    let topEmptyCellIndexPath = self.nextIndexPath(for: result)
                    let topEmptyCellIdentifier = field.name + "_empty_top"
                    let topEmptyCell = EmptyTableViewCellModel(indexPath: topEmptyCellIndexPath, identifier: topEmptyCellIdentifier)
                    
                    result.append(topEmptyCell)
                    
                    let dropdownIndexPath = self.nextIndexPath(for: result)
                    let countries = type(of: self).cachedAddressFieldsData?.countryFormats.tap_allKeys ?? Country.all
                    
                    let dropdownCell = AddressDropdownFieldTableViewCellModel(indexPath: dropdownIndexPath,
                                                                              field: field,
                                                                              specification: fieldSpecification,
                                                                              allValues: countries,
                                                                              preselectedValue: country,
                                                                              inputListener: self.validator,
                                                                              dataStorage: self.validator)
                    
                    result.append(dropdownCell)
                    
                    let bottomEmptyCellIndexPath = self.nextIndexPath(for: result)
                    let bottomEmptyCellIdentifier = field.name + "_empty_bottom"
                    let bottomEmptyCell = EmptyTableViewCellModel(indexPath: bottomEmptyCellIndexPath, identifier: bottomEmptyCellIdentifier)
                    
                    result.append(bottomEmptyCell)
                    
                case .textInput(_):
                    
                    let indexPath = self.nextIndexPath(for: result)
                    let inputCellModel = AddressTextInputFieldTableViewCellModel(indexPath: indexPath,
                                                                                 addressField: field,
                                                                                 specification: fieldSpecification,
                                                                                 inputListener: self.validator,
                                                                                 dataStorage: self.validator,
                                                                                 dataManager: self)
                    
                    result.append(inputCellModel)
                }
            }
            
            self.cellViewModels = result
        }
    }
    
    @inline(__always) private func nextIndexPath(for temporaryResult: [Any]) -> IndexPath {
        
        return IndexPath(row: temporaryResult.count, section: 0)
    }
    
    private func previousModelInputField(for model: TableViewCellViewModel) -> UITextField? {
        
        guard let index = self.cellViewModels.firstIndex(where: { $0.indexPath == model.indexPath }), index > 0 else { return nil }
        
        if let previousModel = self.cellViewModels[index - 1] as? AddressTextInputFieldTableViewCellModel {
            
            return previousModel.cell?.inputField
        }
        else {
            
            return nil
        }
    }
    
    private func nextModelInputField(for model: TableViewCellViewModel) -> UITextField? {
        
        guard let index = self.cellViewModels.firstIndex(where: { $0.indexPath == model.indexPath }), index + 1 < self.cellViewModels.count else { return nil }
        
        if let nextModel = self.cellViewModels[index + 1] as? AddressTextInputFieldTableViewCellModel {
            
            return nextModel.cell?.inputField
        }
        else {
            
            return nil
        }
    }
    
    private func calculateRequiredDescriptionWidthAndAssignToModels() {
        
        let fieldModels = self.cellViewModels.compactMap { $0 as? AddressFieldTableViewCellModel }
        let titles = fieldModels.map { $0.fieldSpecification.placeholder }
        
        let widths: [CGFloat] = titles.map {
            
            let boundingSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let boundingRect = $0.boundingRect(with: boundingSize,
                                               options: [.usesLineFragmentOrigin, .usesDeviceMetrics],
                                               attributes: [.font: Constants.descriptionFont],
                                               context: nil)
            return boundingRect.size.tap_ceiled.width
        }
        
        guard let maxWidth = widths.max() else { return }
        
        let widthToApply = maxWidth + Constants.extraDescriptionWidth
        
        fieldModels.forEach { $0.descriptionWidth = widthToApply }
    }
}
