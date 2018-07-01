//
//  AddressFieldsDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGSize
import struct TapAdditionsKit.TypeAlias
import class UIKit.UIFont.UIFont
import class UIKit.UIResponder.UIResponder

/// Data manager to manager address fields.
internal class AddressFieldsDataManager {
    
    // MARK: - Internal -
    
    internal struct Constants {
        
        fileprivate static let countryTopEmptyCellModelIdentifier = "country_top_empty_cell_model"
        fileprivate static let countryBottomEmptyCellModelIdentifier = "country_bottom_empty_cell_model"
        
        internal static let countryPlaceholder = "Country"
        
        fileprivate static let descriptionFont: UIFont = .helveticaNeueRegular(15.0)
        fileprivate static let extraDescriptionWidth: CGFloat = 3.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    internal unowned let validator: CardAddressValidator
    
    internal private(set) var visibleCellViewModels: [CellViewModel] = [] {
        
        didSet {
            
            self.calculateRequiredDescriptionWidthAndAssignToModels()
            self.reloadClosure?()
        }
    }
    
    internal var reloadClosure: TypeAlias.ArgumentlessClosure?
    
    internal let countryAddressField: AddressField = {
        
        let field = AddressField(inputType: .dropdown,
                                 placeholder: Constants.countryPlaceholder,
                                 isRequired: true,
                                 inputOrder: 0,
                                 displayOrder: Int.max)
        return field
    }()
    
    // MARK: Methods
    
    internal init(validator: CardAddressValidator) {
        
        self.validator = validator
        
        self.generateCellViewModels()
    }
    
    internal func tableViewWillDisplayCell(connectedTo model: CellViewModel) {
        
        if let inputFieldModel = model as? AddressTextInputFieldTableViewCellModel {
            
            let modelInputField = inputFieldModel.cell?.inputField
            let previousInputField = self.previousVisibleModelInputField(for: model)
            
            previousInputField?.nextField = modelInputField
            
            modelInputField?.previousField = previousInputField
            modelInputField?.nextField = nil
        }
    }
    
    internal func firstExisingCellModel<ModelType: AddressFieldTableViewCellModel>(with placeholder: String) -> ModelType? {
        
        return self.allCellViewModels.first(where: { ($0 as? ModelType)?.addressField.placeholder == placeholder }) as? ModelType
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var allCellViewModels: [CellViewModel] = [] {
        
        didSet {
            
            self.filterVisibleCellViewModels()
        }
    }
    
    // MARK: Methods
    
    private func generateCellViewModels() {
        
        var result: [CellViewModel] = self.allCellViewModels
        
        self.generateStaticTopAddressFields(fillingInto: &result)
        
        // TODO: Apply real address format logic when Address Format API is ready.
        
//        guard let addressFormat = self.validator.binInformation?.addressFormat, addressFormat.count > 0 else {
//
//            self.allCellViewModels = result
//            return
//        }
//
//        addressFormat.forEach { addressField in
//
//            if let _: AddressTextInputFieldTableViewCellModel = self.firstExisingCellModel(with: addressField.placeholder) { } else {
//
//                let fieldCellModel = AddressTextInputFieldTableViewCellModel(indexPath: self.nextIndexPath(for: result),
//                                                                             addressField: addressField,
//                                                                             inputListener: self.validator,
//                                                                             dataStorage: self.validator)
//                result.append(fieldCellModel)
//            }
//        }
        
        self.allCellViewModels = result
    }
    
    private func generateStaticTopAddressFields(fillingInto result: inout [CellViewModel]) {
        
        if let _: EmptyTableViewCellModel = self.firstExisingCellModel(with: Constants.countryTopEmptyCellModelIdentifier) { } else {
            
            let topEmptyCellViewModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                identifier: Constants.countryTopEmptyCellModelIdentifier)
            result.append(topEmptyCellViewModel)
        }
        
        if let _: AddressDropdownFieldTableViewCellModel = self.firstExisingCellModel(with: Constants.countryPlaceholder) { } else {
            
            let countryCellViewModel = AddressDropdownFieldTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                              field: self.countryAddressField,
                                                                              allValues: Country.all,
                                                                              preselectedValue: self.validator.country,
                                                                              inputListener: self.validator,
                                                                              dataStorage: self.validator)
            result.append(countryCellViewModel)
        }
        
        if let _: EmptyTableViewCellModel = self.firstExisingCellModel(with: Constants.countryBottomEmptyCellModelIdentifier) { } else {
            
            let bottomEmptyCellViewModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                   identifier: Constants.countryBottomEmptyCellModelIdentifier)
            result.append(bottomEmptyCellViewModel)
        }
    }
    
    private func firstExisingCellModel<ModelType: EmptyTableViewCellModel>(with identifier: String) -> ModelType? {
        
        return self.allCellViewModels.first(where: { ($0 as? ModelType)?.identifier == identifier }) as? ModelType
    }
    
    private func filterVisibleCellViewModels() {
        
        var result: [CellViewModel] = []
        
        if let topEmptyCellModelBeforeCountry: EmptyTableViewCellModel = self.firstExisingCellModel(with: Constants.countryTopEmptyCellModelIdentifier) {
            
            topEmptyCellModelBeforeCountry.indexPath = self.nextIndexPath(for: result)
            result.append(topEmptyCellModelBeforeCountry)
        }
        
        if let countryCellModel: AddressDropdownFieldTableViewCellModel = self.firstExisingCellModel(with: Constants.countryPlaceholder) {
            
            countryCellModel.indexPath = self.nextIndexPath(for: result)
            result.append(countryCellModel)
        }
        
        if let bottomEmptyCellModelAfterCountry: EmptyTableViewCellModel = self.firstExisingCellModel(with: Constants.countryBottomEmptyCellModelIdentifier) {
            
            bottomEmptyCellModelAfterCountry.indexPath = self.nextIndexPath(for: result)
            result.append(bottomEmptyCellModelAfterCountry)
        }

        // TODO: Apply real logic when Address Format API is ready.
        
//        guard let addressFormat = self.validator.binInformation?.addressFormat, addressFormat.count > 0 else {
//
//            self.visibleCellViewModels = result
//            return
//        }
//
//        let sortedAddressFormat = addressFormat.sorted { $0.inputOrder < $1.inputOrder }
//
//        sortedAddressFormat.forEach { addressField in
//
//            if let addressCellViewModel: AddressTextInputFieldTableViewCellModel = self.firstExisingCellModel(with: addressField.placeholder) {
//
//                addressCellViewModel.indexPath = self.nextIndexPath(for: result)
//                result.append(addressCellViewModel)
//            }
//        }
        
        self.visibleCellViewModels = result
    }
    
    @inline(__always) private func nextIndexPath(for temporaryResult: [Any]) -> IndexPath {
        
        return IndexPath(row: temporaryResult.count, section: 0)
    }
    
    private func previousVisibleModelInputField(for model: CellViewModel) -> UIResponder? {
        
        guard let index = self.visibleCellViewModels.index(where: { $0.indexPath == model.indexPath }), index > 0 else { return nil }
        
        if let previousModel = self.visibleCellViewModels[index - 1] as? AddressTextInputFieldTableViewCellModel {
            
            return previousModel.cell?.inputField
        }
        else {
            
            return nil
        }
    }
    
    private func calculateRequiredDescriptionWidthAndAssignToModels() {
        
        guard let fieldModels = (self.visibleCellViewModels.filter { $0 is AddressFieldTableViewCellModel }) as? [AddressFieldTableViewCellModel] else { return }
        let titles = fieldModels.map { $0.addressField.placeholder }
        
        let widths: [CGFloat] = titles.map {
            
            let boundingSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let boundingRect = $0.boundingRect(with: boundingSize,
                                               options: [.usesLineFragmentOrigin, .usesDeviceMetrics],
                                               attributes: [.font: Constants.descriptionFont],
                                               context: nil)
            return boundingRect.size.ceiled.width
        }
        
        guard let maxWidth = widths.max() else { return }
        
        let widthToApply = maxWidth + Constants.extraDescriptionWidth
        
        fieldModels.forEach { $0.descriptionWidth = widthToApply }
    }
}
