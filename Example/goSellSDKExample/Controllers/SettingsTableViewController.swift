//
//  SettingsTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   Foundation.NSIndexPath.IndexPath
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode
import class    ObjectiveC.NSObject.NSObject
import class    UIKit.UILabel.UILabel
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import var      UIKit.UITableView.UITableViewAutomaticDimension
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableView.UITableViewRowAction
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UIView.UIView

internal class SettingsTableViewController: ModalNavigationTableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: SettingsTableViewControlerDelegate?
    
    internal var settings: Settings = .default {
        
        didSet {
            
            self.currentSettings = self.settings
        }
    }
    
    internal override var isDoneButtonEnabled: Bool {
        
        return true
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.currentSettings == nil {
            
            self.currentSettings = .default
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.updateWithCurrentSettings()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let customersListController = segue.destination as? CustomersListViewController {
            
            customersListController.delegate = self
            customersListController.selectedCustomer = self.currentSettings?.customer
        }
        else if let taxController = (segue.destination as? UINavigationController)?.rootViewController as? TaxViewController {
            
            taxController.delegate = self
            taxController.tax = self.selectedTax
        }
        else if let shippingController = (segue.destination as? UINavigationController)?.rootViewController as? ShippingViewController {
            
            shippingController.delegate = self
            shippingController.shipping = self.selectedShipping
        }
        else if let caseSelectionController = segue.destination as? CaseSelectionTableViewController, let reuseIdentifier = self.selectedCellReuseIdentifier {
            
            caseSelectionController.delegate = self
            
            switch reuseIdentifier {
                
            case Constants.currencyCellReuseIdentifier:
                
                caseSelectionController.title = "Currency"
                caseSelectionController.allValues = Currency.all
                caseSelectionController.preselectedValue = self.currentSettings?.currency
                
            case Constants.modeCellReuseIdentifier:
                
                caseSelectionController.title = "Mode"
                caseSelectionController.allValues = TransactionMode.all
                caseSelectionController.preselectedValue = self.currentSettings?.mode
                
            default:
                
                break
            }
        }
    }
    
    internal override func doneButtonClicked() {
        
        guard let nonnullSettings = self.currentSettings else { return }
        
        self.delegate?.settingsViewController(self, didFinishWith: nonnullSettings)
    }
    
    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else {
            
            return UITableViewAutomaticDimension
        }
        
        switch reuseIdentifier {
            
        case Constants.taxListCellReuseIdentifier:
            
            return max(100.0 * CGFloat( self.currentSettings?.taxes.count ?? 0 ), 1.0)
            
        case Constants.shippingListCellReuseIdentifier:
            
            return max(65.0 * CGFloat( self.currentSettings?.shippingList.count ?? 0 ), 1.0)
            
        default:
            
            return UITableViewAutomaticDimension
            
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else { return }
        
        switch reuseIdentifier {
            
        case Constants.currencyCellReuseIdentifier, Constants.modeCellReuseIdentifier:
            
            self.showCaseSelectionViewController(with: reuseIdentifier)
            
        case Constants.customerCellReuseIdentifier:
            
            self.showCustomersListViewController()
            
        default:
            
            break
        }
    }
    
    // MARK: - Fileprivate -
    
    fileprivate class ShippingTableViewHandler: NSObject {
        
        fileprivate let settings: Settings
        fileprivate unowned let settingsController: SettingsTableViewController
        
        fileprivate init(settings: Settings, settingsController: SettingsTableViewController) {
            
            self.settings = settings
            self.settingsController = settingsController
        }
    }
    
    fileprivate class TaxesTableViewHandler: NSObject {
        
        fileprivate let settings: Settings
        fileprivate unowned let settingsController: SettingsTableViewController
        
        fileprivate init(settings: Settings, settingsController: SettingsTableViewController) {
            
            self.settings = settings
            self.settingsController = settingsController
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let modeCellReuseIdentifier          = "mode_cell"
        fileprivate static let currencyCellReuseIdentifier      = "currency_cell"
        fileprivate static let customerCellReuseIdentifier      = "customer_cell"
        fileprivate static let taxListCellReuseIdentifier       = "tax_list_cell"
        fileprivate static let shippingListCellReuseIdentifier  = "shiping_list_cell"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var modeValueLabel: UILabel?
    @IBOutlet private weak var currencyValueLabel: UILabel?
    @IBOutlet private weak var customerNameLabel: UILabel?
    
    @IBOutlet private weak var shippingTableView: UITableView? {
        
        didSet {
            
            self.shippingTableView?.dataSource = self.shippingTableViewHandler
            self.shippingTableView?.delegate = self.shippingTableViewHandler
        }
    }
    
    @IBOutlet private weak var taxesTableView: UITableView? {
        
        didSet {
            
            self.taxesTableView?.dataSource = self.taxesTableViewHandler
            self.taxesTableView?.delegate = self.taxesTableViewHandler
        }
    }
    
    private var currentSettings: Settings? {
        
        didSet {
            
            self.updateWithCurrentSettings()
        }
    }
    
    private var selectedCellReuseIdentifier: String?
    
    private lazy var shippingTableViewHandler: ShippingTableViewHandler = ShippingTableViewHandler(settings: self.currentSettings ?? .default, settingsController: self)
    private lazy var taxesTableViewHandler: TaxesTableViewHandler = TaxesTableViewHandler(settings: self.currentSettings ?? .default, settingsController: self)
    
    private var selectedTax: Tax?
    private var selectedShipping: Shipping?
    
    // MARK: Methods
    
    private func showCaseSelectionViewController(with reuseIdentifier: String) {
        
        self.selectedCellReuseIdentifier = reuseIdentifier
        self.show(CaseSelectionTableViewController.self)
    }
    
    private func showCustomersListViewController() {
        
        self.show(CustomersListViewController.self)
    }
    
    private func updateWithCurrentSettings() {
        
        self.modeValueLabel?.text = self.currentSettings?.mode.description
        self.currencyValueLabel?.text = self.currentSettings?.currency.localizedSymbol
        
        if let name = self.currentSettings?.customer?.firstName?.trimmingCharacters(in: .whitespacesAndNewlines),
           let surname = self.currentSettings?.customer?.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            self.customerNameLabel?.text = name + " " + surname
        }
        else {
            
            self.customerNameLabel?.text = nil
        }
    }
    
    @IBAction private func addTaxButtonTouchUpInside(_ sender: Any) {
        
        if let selectedTaxIndexPath = self.taxesTableView?.indexPathForSelectedRow {
            
            self.taxesTableView?.deselectRow(at: selectedTaxIndexPath, animated: false)
        }
        
        self.showTaxController()
    }
    
    private func showDetails(of tax: Tax) {
        
        self.showTaxController(with: tax)
    }
    
    private func showTaxController(with tax: Tax? = nil) {
        
        self.selectedTax = tax
        self.show(TaxViewController.self)
    }
    
    @IBAction private func addShippingButtonTouchUpInside(_ sender: Any) {
        
        if let selectedShippingIndexPath = self.shippingTableView?.indexPathForSelectedRow {
            
            self.shippingTableView?.deselectRow(at: selectedShippingIndexPath, animated: false)
        }
        
        self.showShippingController()
    }
    
    private func showDetails(of shipping: Shipping) {
        
        self.showShippingController(with: shipping)
    }
    
    private func showShippingController(with shipping: Shipping? = nil) {
        
        self.selectedShipping = shipping
        self.show(ShippingViewController.self)
    }
}

// MARK: - SeguePresenter
extension SettingsTableViewController: SeguePresenter {}

// MARK: - TaxViewControllerDelegate
extension SettingsTableViewController: TaxViewControllerDelegate {
    
    internal func taxViewController(_ controller: TaxViewController, didFinishWith tax: Tax) {
        
        if let nonnullSelectedTax = self.selectedTax {
            
            if let index = self.currentSettings?.taxes.index(of: nonnullSelectedTax) {
                
                self.currentSettings?.taxes.remove(at: index)
                self.currentSettings?.taxes.insert(tax, at: index)
            }
            else {
                
                self.currentSettings?.taxes.append(tax)
            }
        }
        else {
            
            self.currentSettings?.taxes.append(tax)
        }
        
        self.taxesTableView?.reloadData()
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// MARK: - ShippingViewControllerDelegate
extension SettingsTableViewController: ShippingViewControllerDelegate {
    
    internal func shippingViewController(_ controller: ShippingViewController, didFinishWith shipping: Shipping) {
        
        if let nonnullSelectedShipping = self.selectedShipping {
            
            if let index = self.currentSettings?.shippingList.index(of: nonnullSelectedShipping) {
                
                self.currentSettings?.shippingList.remove(at: index)
                self.currentSettings?.shippingList.insert(shipping, at: index)
            }
            else {
                
                self.currentSettings?.shippingList.append(shipping)
            }
        }
        else {
            
            self.currentSettings?.shippingList.append(shipping)
        }
        
        self.shippingTableView?.reloadData()
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// MARK: - CaseSelectionTableViewControllerDelegate
extension SettingsTableViewController: CaseSelectionTableViewControllerDelegate {
    
    internal func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value) {
        
        guard let reuseIdentifier = self.selectedCellReuseIdentifier else { return }
        
        switch reuseIdentifier {
            
        case Constants.modeCellReuseIdentifier:
            
            if let mode = value as? TransactionMode {
                
                self.currentSettings?.mode = mode
            }
            
        case Constants.currencyCellReuseIdentifier:
            
            if let currency = value as? Currency {
                
                self.currentSettings?.currency = currency
            }
            
        default:
            
            break
        }
        
        self.selectedCellReuseIdentifier = nil
    }
}

// MARK: - CustomersListViewControllerDelegate
extension SettingsTableViewController: CustomersListViewControllerDelegate {
    
    internal func customersListViewController(_ controller: CustomersListViewController, didFinishWith customer: Customer?) {
        
        self.currentSettings?.customer = customer
        self.updateWithCurrentSettings()
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController.TaxesTableViewHandler: UITableViewDataSource {
    
    private var taxes: [Tax] {
        
        return self.settings.taxes
    }
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.taxes.count
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaxTableViewCell.className) as? TaxTableViewCell else {
            
            fatalError("Failed to load \(TaxTableViewCell.className) from storyboard.")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController.TaxesTableViewHandler: UITableViewDelegate {
    
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
        self.settingsController.showDetails(of: tax)
    }
    
    fileprivate func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
            
            self.settings.taxes.remove(at: cellIndexPath.row)
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
            
            self.settingsController.tableView.beginUpdates()
            self.settingsController.tableView.endUpdates()
        }
        
        return [deleteAction]
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController.ShippingTableViewHandler: UITableViewDataSource {
    
    private var shippingList: [Shipping] {
        
        return self.settings.shippingList
    }
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.shippingList.count
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShippingTableViewCell.className) as? ShippingTableViewCell else {
            
            fatalError("Failed to load \(ShippingTableViewCell.className) from storyboard.")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController.ShippingTableViewHandler: UITableViewDelegate {
    
    fileprivate func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let shippingCell = cell as? ShippingTableViewCell else {
            
            fatalError("Somehow cell class is wrong.")
        }
        
        let shipping = self.shippingList[indexPath.row]
        
        let titleText = shipping.name
        let amountText = "\(shipping.amount)"
        
        shippingCell.setTitleText(titleText, amountText: amountText)
    }
    
    fileprivate func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let shipping = self.shippingList[indexPath.row]
        self.settingsController.showDetails(of: shipping)
    }
    
    fileprivate func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
            
            self.settings.shippingList.remove(at: cellIndexPath.row)
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
            
            self.settingsController.tableView.beginUpdates()
            self.settingsController.tableView.endUpdates()
        }
        
        return [deleteAction]
    }
}
