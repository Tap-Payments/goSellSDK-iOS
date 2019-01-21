//
//  SettingsTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   Foundation.NSIndexPath.IndexPath
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class	goSellSDK.goSellSDK
import enum		goSellSDK.SDKAppearanceMode
import enum     goSellSDK.SDKMode
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode
import class    ObjectiveC.NSObject.NSObject
import enum		UIKit.NSText.NSTextAlignment
import class	UIKit.UIApplication.UIApplication
import class    UIKit.UILabel.UILabel
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class	UIKit.UISwitch.UISwitch
import class    UIKit.UITableView.UITableView
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
		self.updateAlignments()
        self.updateWithCurrentSettings()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let customersListController = segue.destination as? CustomersListViewController {
            
            customersListController.delegate            = self
            customersListController.mode                = self.currentSettings?.sdkMode ?? .sandbox
            customersListController.selectedCustomer    = self.currentSettings?.customer
        }
        else if let taxController = (segue.destination as? UINavigationController)?.tap_rootViewController as? TaxViewController {
            
            taxController.delegate  = self
            taxController.tax       = self.selectedTax
        }
        else if let shippingController = (segue.destination as? UINavigationController)?.tap_rootViewController as? ShippingViewController {
            
            shippingController.delegate = self
            shippingController.shipping = self.selectedShipping
        }
        else if let caseSelectionController = segue.destination as? CaseSelectionTableViewController, let reuseIdentifier = self.selectedCellReuseIdentifier {
            
            caseSelectionController.delegate = self
            
            switch reuseIdentifier {
				
			case Constants.sdkLanguageCelReuseIdentifier:
				
				caseSelectionController.title = "SDK Language"
				caseSelectionController.allValues = Language.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.sdkLanguage
				
            case Constants.sdkModeCellReuseIdentifier:
                
                caseSelectionController.title = "SDK Mode"
                caseSelectionController.allValues = SDKMode.allCases
                caseSelectionController.preselectedValue = self.currentSettings?.sdkMode
				
			case Constants.appearanceModeCellReuseIdentifier:
				
				caseSelectionController.title = "Appearance Mode"
				caseSelectionController.allValues = SDKAppearanceMode.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.appearanceMode
				
            case Constants.transactionModeCellReuseIdentifier:
                
                caseSelectionController.title = "Transaction Mode"
                caseSelectionController.allValues = TransactionMode.allCases
                caseSelectionController.preselectedValue = self.currentSettings?.transactionMode
                
            case Constants.currencyCellReuseIdentifier:
                
                caseSelectionController.title = "Currency"
                caseSelectionController.allValues = Currency.allCases
                caseSelectionController.preselectedValue = self.currentSettings?.currency
                
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
            
            return UITableView.automaticDimension
        }
        
        switch reuseIdentifier {
            
        case Constants.taxListCellReuseIdentifier:
            
            return max(100.0 * CGFloat( self.currentSettings?.taxes.count ?? 0 ), 1.0)
            
        case Constants.shippingListCellReuseIdentifier:
            
            return max(65.0 * CGFloat( self.currentSettings?.shippingList.count ?? 0 ), 1.0)
            
        default:
            
            return UITableView.automaticDimension
            
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else { return }
        
        switch reuseIdentifier {
            
        case Constants.currencyCellReuseIdentifier,
			 Constants.sdkLanguageCelReuseIdentifier,
			 Constants.sdkModeCellReuseIdentifier,
			 Constants.appearanceModeCellReuseIdentifier,
			 Constants.transactionModeCellReuseIdentifier:
            
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
		
		fileprivate static let sdkLanguageCelReuseIdentifier		= "sdk_language_cell"
        fileprivate static let sdkModeCellReuseIdentifier          	= "sdk_mode_cell"
		fileprivate static let appearanceModeCellReuseIdentifier	= "appearance_mode_cell"
        fileprivate static let transactionModeCellReuseIdentifier   = "transaction_mode_cell"
        fileprivate static let currencyCellReuseIdentifier          = "currency_cell"
        fileprivate static let customerCellReuseIdentifier          = "customer_cell"
        fileprivate static let taxListCellReuseIdentifier           = "tax_list_cell"
        fileprivate static let shippingListCellReuseIdentifier      = "shiping_list_cell"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
	
	@IBOutlet private weak var sdkLanguageValueLabel: UILabel?
    @IBOutlet private weak var sdkModeValueLabel: UILabel?
	@IBOutlet private weak var appearanceModeValueLabel: UILabel?
    @IBOutlet private weak var transactionModeValueLabel: UILabel?
    @IBOutlet private weak var currencyValueLabel: UILabel?
    @IBOutlet private weak var customerNameLabel: UILabel?
	@IBOutlet private weak var threeDSecureSwitch: UISwitch?
	
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
		
		self.sdkLanguageValueLabel?.text		= self.currentSettings?.sdkLanguage.description
        self.sdkModeValueLabel?.text            = self.currentSettings?.sdkMode.description
		self.appearanceModeValueLabel?.text		= self.currentSettings?.appearanceMode.description
        self.transactionModeValueLabel?.text    = self.currentSettings?.transactionMode.description
        self.currencyValueLabel?.text           = self.currentSettings?.currency.localizedSymbol
		self.threeDSecureSwitch?.isOn			= self.currentSettings?.isThreeDSecure ?? Settings.default.isThreeDSecure
        
        if let name = self.currentSettings?.customer?.customer.firstName?.trimmingCharacters(in: .whitespacesAndNewlines),
           let surname = self.currentSettings?.customer?.customer.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            self.customerNameLabel?.text = name + " " + surname
        }
        else {
            
            self.customerNameLabel?.text = nil
        }
    }
	
	@IBAction private func threeDSecureSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.isThreeDSecure = self.threeDSecureSwitch?.isOn ?? Settings.default.isThreeDSecure
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
	
	private func updateAlignments() {
		
		let trailing: NSTextAlignment = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .right : .left
		
		self.sdkLanguageValueLabel?.textAlignment		= trailing
		self.sdkModeValueLabel?.textAlignment			= trailing
		self.appearanceModeValueLabel?.textAlignment	= trailing
		self.transactionModeValueLabel?.textAlignment	= trailing
		self.currencyValueLabel?.textAlignment			= trailing
		self.customerNameLabel?.textAlignment			= trailing
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
			
		case Constants.sdkLanguageCelReuseIdentifier:
			
			if let language = value as? Language {
				
				self.currentSettings?.sdkLanguage = language
			}
			
        case Constants.sdkModeCellReuseIdentifier:
            
            if let sdkMode = value as? SDKMode {
                
                self.currentSettings?.sdkMode = sdkMode
                
                if self.currentSettings?.customer?.environment != sdkMode {
                    
                    self.currentSettings?.customer = nil
                }
            }
			
		case Constants.appearanceModeCellReuseIdentifier:
			
			if let appearanceMode = value as? SDKAppearanceMode {
				
				self.currentSettings?.appearanceMode = appearanceMode
			}
            
        case Constants.transactionModeCellReuseIdentifier:
            
            if let transactionMode = value as? TransactionMode {
                
                self.currentSettings?.transactionMode = transactionMode
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
    
    internal func customersListViewController(_ controller: CustomersListViewController, didFinishWith customer: EnvironmentCustomer?) {
        
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaxTableViewCell.tap_className) as? TaxTableViewCell else {
            
            fatalError("Failed to load \(TaxTableViewCell.tap_className) from storyboard.")
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShippingTableViewCell.tap_className) as? ShippingTableViewCell else {
            
            fatalError("Failed to load \(ShippingTableViewCell.tap_className) from storyboard.")
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
