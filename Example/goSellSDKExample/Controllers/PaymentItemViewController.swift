//
//  PaymentItemViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    Dispatch.DispatchQueue
import Foundation
import class    goSellSDK.AmountModificator
import enum     goSellSDK.AmountModificatorType
import enum     goSellSDK.Area
import enum     goSellSDK.Duration
import enum     goSellSDK.ElectricCharge
import enum     goSellSDK.ElectricCurrent
import enum     goSellSDK.Energy
import enum     goSellSDK.Length
import enum     goSellSDK.Mass
import enum     goSellSDK.Measurement
import class    goSellSDK.PaymentItem
import enum     goSellSDK.Power
import class    goSellSDK.Quantity
import class    goSellSDK.Tax
import enum     goSellSDK.Volume
import class    ObjectiveC.NSObject.NSObject
import class    UIKit.UIBarButtonItem.UIBarButtonItem
import class    UIKit.UILabel.UILabel
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UITableViewController.UITableViewController
import class    UIKit.UITextField.UITextField
import class    UIKit.UITextView.UITextView
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

#if !swift(>=4.2)
import var		UIKit.UITableView.UITableViewAutomaticDimension
#endif

internal class PaymentItemViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: PaymentItemViewControllerDelegate?
    
    internal var paymentItem: PaymentItem? {
        
        didSet {
            
            self.updateTitle()
            
            if let nonnullItem = self.paymentItem {
                
                self.currentPaymentItem = nonnullItem.copy() as! PaymentItem
            }
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        return !self.currentPaymentItem.title.isEmpty && self.currentPaymentItem.quantityOld.value > 0.0 && self.currentPaymentItem.amountPerUnit > 0.0
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.updateTitle()
        
        self.addInputFieldTextChangeObserver()
        
        self.tableView.tableFooterView = UIView()
        
        self.updateWithCurrentPaymentItemInfo()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let taxController = (segue.destination as? UINavigationController)?.tap_rootViewController as? TaxViewController {
            
            taxController.delegate = self
            taxController.tax = self.selectedTax
        }
        else if let caseSelectionController = segue.destination as? CaseSelectionTableViewController, let reuseIdentifier = self.selectedCellReuseIdentifier {
            
            caseSelectionController.delegate = self
            
            switch reuseIdentifier {
                
            case Constants.measurementCategoryCellReuseIdentifier:
                
                caseSelectionController.title = "Measurement Category"
                caseSelectionController.allValues = Measurement.allCategoriesWithDefaultUnitsOfMeasurement
                caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.unitOfMeasurement
                
            case Constants.measurementUnitCellReuseIdentifier:
                
                caseSelectionController.title = "Measurement Unit"
                
                switch self.currentPaymentItem.quantityOld.unitOfMeasurement {
                    
                case .area(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .duration(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .electricCharge(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .electricCurrent(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .energy(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .length(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .mass(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .power(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                    
                case .units:
                    
                    break
                    
                case .volume(let measurement):
                    
                    caseSelectionController.allValues = type(of: measurement).allCases
                    caseSelectionController.preselectedValue = self.currentPaymentItem.quantityOld.measurementUnit
                }
                
            case Constants.discountTypeCellReuseIdentifier:
                
                caseSelectionController.title = "Discount Type"
                
                caseSelectionController.allValues = AmountModificatorType.allCases
                caseSelectionController.preselectedValue = self.currentPaymentItem.discount?.type
                
            default:
                
                break
            }
        }
    }
    
    internal override func doneButtonClicked() {
        
        self.delegate?.paymentItemViewController(self, didFinishWith: self.currentPaymentItem)
    }
    
    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == Constants.taxListCellReuseIdentifier {
            
            return max(100.0 * CGFloat( self.currentPaymentItem.taxes?.count ?? 0 ), 1.0)
        }
        else {
            
			#if swift(>=4.2)
			return UITableView.automaticDimension
			#else
			return UITableViewAutomaticDimension
			#endif
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else { return }
        
        switch reuseIdentifier {
            
        case Constants.measurementCategoryCellReuseIdentifier, Constants.discountTypeCellReuseIdentifier:
            
            self.showCaseSelectionController(with: reuseIdentifier)
            
        case Constants.measurementUnitCellReuseIdentifier:
            
            guard self.currentPaymentItem.quantityOld.unitOfMeasurement != .units else { break }
            
            self.showCaseSelectionController(with: reuseIdentifier)
            
        default:
            
            break
        }
    }
    
    deinit {
        
        self.removeInputFieldTextChangeObserver()
    }
    
    // MARK: - Fileprivate -
    
    fileprivate class TaxesTableViewHandler: NSObject {
        
        fileprivate let currentItem: PaymentItem
        fileprivate unowned let paymentItemController: PaymentItemViewController
        
        fileprivate init(item: PaymentItem, controller: PaymentItemViewController) {
            
            self.currentItem = item
            self.paymentItemController = controller
            super.init()
        }
    }
    
    // MARK: Methods
    
    fileprivate func showDetails(of existingTax: Tax) {
        
        self.showTaxController(with: existingTax)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let measurementCategoryCellReuseIdentifier   = "measurement_category_cell"
        fileprivate static let measurementUnitCellReuseIdentifier       = "measurement_unit_cell"
        fileprivate static let discountTypeCellReuseIdentifier          = "discount_type_cell"
        fileprivate static let taxListCellReuseIdentifier               = "tax_list_cell"
        
        //@available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var titleTextField: UITextField?
    @IBOutlet private weak var descriptionTextView: UITextView?
    @IBOutlet private weak var selectedMeasurementCategoryLabel: UILabel?
    @IBOutlet private weak var selectedMeasurementSubcategoryLabel: UILabel?
    @IBOutlet private weak var quantityValueTextField: UITextField?
    @IBOutlet private weak var amountPerUnitTextField: UITextField?
    @IBOutlet private weak var selectedDiscountTypeLabel: UILabel?
    @IBOutlet private weak var discountValueTextField: UITextField?
    @IBOutlet private weak var taxesTableView: UITableView? {
        
        didSet {
            
            self.taxesTableView?.dataSource = self.taxesTableViewHandler
            self.taxesTableView?.delegate = self.taxesTableViewHandler
        }
    }
    
    private var currentPaymentItem: PaymentItem = PaymentItem(title: "",
                                                              descriptionText: nil,
                                                              quantity: 0,
                                                              amountPerUnit: 0.0,
                                                              discount: nil,
                                                              taxes: []) {
                                                                
        didSet {
            
            self.updateWithCurrentPaymentItemInfo()
        }
    }
    
    private var selectedCellReuseIdentifier: String?
    
    private lazy var taxesTableViewHandler = TaxesTableViewHandler(item: self.currentPaymentItem, controller: self)
    private var selectedTax: Tax?
    
    // MARK: Methods
    
    private func updateTitle() {
        
        if self.paymentItem == nil {
            
            self.title = "Add Payment Item"
        }
        else {
            
            self.title = "Edit Payment Item"
        }
    }
    
    private func updateCurrentPaymentItemInfoFromInputFields() {
        
        if let itemTitle = self.titleTextField?.text, !itemTitle.isEmpty {
            
            self.currentPaymentItem.title = itemTitle
        }
        else {
            
            self.currentPaymentItem.title = ""
        }
        
        self.currentPaymentItem.descriptionText = self.descriptionTextView?.text
        
        if let quantityValue = self.quantityValueTextField?.text?.tap_decimalValue, quantityValue > 0.0 {
            
            self.currentPaymentItem.quantityOld.value = quantityValue
        }
        else {
            
            self.currentPaymentItem.quantityOld.value = 0.0
        }
        
        if let amountPerUnit = self.amountPerUnitTextField?.text?.tap_decimalValue, amountPerUnit > 0.0 {
            
            self.currentPaymentItem.amountPerUnit = amountPerUnit
        }
        else {
            
            self.currentPaymentItem.amountPerUnit = 0.0
        }
        
        if let discountType = self.currentPaymentItem.discount?.type {
            
            let discountValue = self.discountValueTextField?.text?.tap_decimalValue ?? 0.0
            self.currentPaymentItem.discount = AmountModificator(type: discountType, value: discountValue)
        }
        else {
            
            self.currentPaymentItem.discount = nil
        }
    }
    
    private func updateWithCurrentPaymentItemInfo() {
        
        self.titleTextField?.text = self.currentPaymentItem.title
        self.descriptionTextView?.text = self.currentPaymentItem.descriptionText
        self.selectedMeasurementCategoryLabel?.text = self.currentPaymentItem.quantityOld.measurementGroup
        self.selectedMeasurementSubcategoryLabel?.text = self.currentPaymentItem.quantityOld.measurementUnit
        self.quantityValueTextField?.text = "\(self.currentPaymentItem.quantityOld.value)"
        self.amountPerUnitTextField?.text = "\(self.currentPaymentItem.amountPerUnit)"
        self.selectedDiscountTypeLabel?.text = self.currentPaymentItem.discount?.type.description
        self.discountValueTextField?.text = "\(self.currentPaymentItem.discount?.value ?? 0.0)"
    }
    
    @IBAction private func addTaxButtonTouchUpInside(_ sender: Any) {
        
        if let selectedTaxIndexPath = self.taxesTableView?.indexPathForSelectedRow {
            
            self.taxesTableView?.deselectRow(at: selectedTaxIndexPath, animated: false)
        }
    
        self.showTaxController()
    }
    
    private func showTaxController(with tax: Tax? = nil) {
        
        self.selectedTax = tax
        self.show(TaxViewController.self)
    }
    
    private func showCaseSelectionController(with cellReuseIdentifier: String) {
        
        self.selectedCellReuseIdentifier = cellReuseIdentifier
        self.show(CaseSelectionTableViewController.self)
    }
}

// MARK: - InputFieldObserver
extension PaymentItemViewController: InputFieldObserver {
    
    internal func inputFieldTextChanged(_ notification: Notification) {
        
        self.updateCurrentPaymentItemInfoFromInputFields()
        self.updateDoneButtonState()
    }
}

// MARK: - TaxViewControllerDelegate
extension PaymentItemViewController: TaxViewControllerDelegate {
    
    internal func taxViewController(_ controller: TaxViewController, didFinishWith tax: Tax) {
     
        if let nonnullSelectedTax = self.selectedTax {
            
            if let index = self.currentPaymentItem.taxes?.firstIndex(of: nonnullSelectedTax) {
                
                self.currentPaymentItem.taxes?.remove(at: index)
                self.currentPaymentItem.taxes?.insert(tax, at: index)
            }
            else {
                
                self.currentPaymentItem.taxes?.append(tax)
            }
        }
        else {
            
            self.currentPaymentItem.taxes?.append(tax)
        }
        
        self.taxesTableView?.reloadData()
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// MARK: - CaseSelectionTableViewControllerDelegate
extension PaymentItemViewController: CaseSelectionTableViewControllerDelegate {
    
    internal func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value) {
        
        defer {
            
            self.selectedCellReuseIdentifier = nil
            self.updateWithCurrentPaymentItemInfo()
        }
        
        guard let reuseIdentifier = self.selectedCellReuseIdentifier else { return }
        
        switch reuseIdentifier {
            
        case Constants.measurementCategoryCellReuseIdentifier:
            
            guard let unit = value as? Measurement else { return }
            self.currentPaymentItem.quantityOld.unitOfMeasurement = unit
            
        case Constants.measurementUnitCellReuseIdentifier:
            
            if let areaUnit = value as? Area {
                
                self.currentPaymentItem.quantityOld.unitOfMeasurement = .area(areaUnit)
            }
            else if let durationUnit = value as? Duration {
                
                self.currentPaymentItem.quantityOld.unitOfMeasurement = .duration(durationUnit)
            }
            else if let lengthUnit = value as? Length {
                
                self.currentPaymentItem.quantityOld.unitOfMeasurement = .length(lengthUnit)
            }
            else if let massUnit = value as? Mass {
                
                self.currentPaymentItem.quantityOld.unitOfMeasurement = .mass(massUnit)
            }
            else if let powerUnit = value as? Power {
                
                self.currentPaymentItem.quantityOld.unitOfMeasurement = .power(powerUnit)
            }
            
        case Constants.discountTypeCellReuseIdentifier:
            
            guard let type = value as? AmountModificatorType else { return }
            
            if let existingDiscount = self.currentPaymentItem.discount {
                
                existingDiscount.type = type
            }
            else {
                
                let discountValue = self.discountValueTextField?.text?.tap_decimalValue ?? 0.0
                self.currentPaymentItem.discount = AmountModificator(type: type, value: discountValue)
            }
            
        default:
            
            return
        }
    }
}

// MARK: - SeguePresenter
extension PaymentItemViewController: SeguePresenter {}

// MARK: - UITableViewDataSource
extension PaymentItemViewController.TaxesTableViewHandler: UITableViewDataSource {
    
    fileprivate var taxes: [Tax] {
        
        return self.currentItem.taxes ?? []
    }
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.taxes.count
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaxTableViewCell.tap_className) as? TaxTableViewCell else {
            
            fatalError("Failed to load \(TaxTableViewCell.tap_className) from storyboard.")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PaymentItemViewController.TaxesTableViewHandler: UITableViewDelegate {
    
    fileprivate func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let taxCell = cell as? TaxTableViewCell else {
            
            fatalError("Somehow cell class is wrong.")
        }
        
        let tax = self.taxes[indexPath.row]
        
        let title = tax.title
        let descriptionText = tax.descriptionText
        let valueText = tax.amount.type.description + ": " + "\(tax.amount.value)"
        
        taxCell.setTitle(title, descriptionText: descriptionText, valueText: valueText)
    }
    
    fileprivate func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tax = self.taxes[indexPath.row]
        self.paymentItemController.showDetails(of: tax)
    }
}
