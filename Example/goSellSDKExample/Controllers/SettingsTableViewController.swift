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
import class	goSellSDK.Destination
import class	goSellSDK.goSellSDK
import enum		goSellSDK.SDKAppearanceMode
import enum     goSellSDK.SDKMode
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode
import class    ObjectiveC.NSObject.NSObject
import enum		UIKit.NSText.NSTextAlignment
import class	UIKit.UIApplication.UIApplication
import class	UIKit.UIBlurEffect.UIBlurEffect
import class	UIKit.UIFont.UIFont
import class    UIKit.UILabel.UILabel
import class    UIKit.UINavigationController.UINavigationController
import class	UIKit.UIStepper.UIStepper
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
		else if let destinationController = (segue.destination as? UINavigationController)?.tap_rootViewController as? DestinationViewController {
			
			destinationController.delegate		= self
			destinationController.destination	= self.selectedDestination
		}
        else if let taxController = (segue.destination as? UINavigationController)?.tap_rootViewController as? TaxViewController {
            
            taxController.delegate  = self
            taxController.tax       = self.selectedTax
        }
        else if let shippingController = (segue.destination as? UINavigationController)?.tap_rootViewController as? ShippingViewController {
            
            shippingController.delegate = self
            shippingController.shipping = self.selectedShipping
        }
		else if let colorSelectionController = segue.destination as? ColorSelectionTableViewController, let reuseIdentifier = self.selectedCellReuseIdentifier {
			
			colorSelectionController.delegate = self
			colorSelectionController.allValues = Color.allCases
			
			switch reuseIdentifier {
				
			case Constants.headerTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Text Color"
				colorSelectionController.preselectedValue = self.currentSettings?.headerTextColor
				
			case Constants.headerBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.headerBackgroundColor
				
			case Constants.headerCancelNormalColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Cancel Normal Color"
				colorSelectionController.preselectedValue = self.currentSettings?.headerCancelNormalTextColor
				
			case Constants.headerCancelHighlightedColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Cancel Highlighted Color"
				colorSelectionController.preselectedValue = self.currentSettings?.headerCancelHighlightedTextColor
				
			case Constants.cardInputTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Text Color"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputTextColor
				
			case Constants.cardInputTextColorInvalidCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Invalid Color"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputInvalidTextColor
				
			case Constants.cardInputTextColorPlaceholderCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Placeholder Color"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputPlaceholderTextColor
				
			case Constants.cardInputDescriptionTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Description Color"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputDescriptionTextColor
				
			case Constants.cardInputSaveCardSwitchOffTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch Off Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputSaveCardSwitchOffTintColor
				
			case Constants.cardInputSaveCardSwitchOnTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch On Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputSaveCardSwitchOnTintColor
				
			case Constants.cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch Thumb Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputSaveCardSwitchThumbTintColor
				
			case Constants.cardInputScanIconFrameTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Scan Icon Frame Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputScanIconFrameTintColor
				
			case Constants.cardInputScanIconTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Scan Icon Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.cardInputScanIconTintColor
				
			case Constants.tapButtonDisabledBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button disabled background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonDisabledBackgroundColor
				
			case Constants.tapButtonEnabledBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button enabled background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonEnabledBackgroundColor
				
			case Constants.tapButtonHighlightedBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button highlighted background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonDisabledBackgroundColor
				
			case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button disabled text color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonDisabledTextColor
				
			case Constants.tapButtonEnabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button enabled text color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonEnabledTextColor
				
			case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button highlighted text color"
				colorSelectionController.preselectedValue = self.currentSettings?.tapButtonHighlightedTextColor
				
			case Constants.backgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.backgroundColor
				
			default:
				
				break
			}
		}
		else if let fontSelectionController = segue.destination as? FontSelectionTableViewController, let reuseIdentifier = self.selectedCellReuseIdentifier {
			
			fontSelectionController.delegate = self
			fontSelectionController.allValues = UIFont.familyNames
			
			switch reuseIdentifier {
				
			case Constants.headerFontCellReuseIdentifier:
				
				fontSelectionController.title = "Header Font"
				fontSelectionController.preselectedValue = self.currentSettings?.headerFont
				
			case Constants.headerCancelFontCellReuseIdentifier:
				
				fontSelectionController.title = "Header Cancel Button Font"
				fontSelectionController.preselectedValue = self.currentSettings?.headerCancelFont
				
			case Constants.cardInputFontCellReuseIdentifier:
				
				fontSelectionController.title = "Card Input Font"
				fontSelectionController.preselectedValue = self.currentSettings?.cardInputFont
				
			case Constants.cardInputDescriptionFontCellReuseIdentifier:
				
				fontSelectionController.title = "Card Input Description Font"
				fontSelectionController.preselectedValue = self.currentSettings?.cardInputDescriptionFont
				
			case Constants.tapButtonFontCellReuseIdentifier:
				
				fontSelectionController.title = "Pay/Save Button Font"
				fontSelectionController.preselectedValue = self.currentSettings?.tapButtonFont
				
			default:
				
				break
			}
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
				
			case Constants.backgroundBlurStyleCellReuseIdentifier:
				
				caseSelectionController.title = "Background Blur Style"
				caseSelectionController.allValues = UIBlurEffect.Style.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.backgroundBlurStyle
				
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
			
		case Constants.destinationsListCellReuseIdentifier:
			
			return max(65.0 * CGFloat( self.currentSettings?.destinations.count ?? 0 ), 1.0)
			
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
			 Constants.transactionModeCellReuseIdentifier,
			 Constants.backgroundBlurStyleCellReuseIdentifier:
			
			self.showCaseSelectionViewController(with: reuseIdentifier)
			
		case Constants.headerTextColorCellReuseIdentifier,
			 Constants.headerBackgroundColorCellReuseIdentifier,
			 Constants.headerCancelNormalColorCellReuseIdentifier,
			 Constants.headerCancelHighlightedColorCellReuseIdentifier,
			 Constants.cardInputTextColorCellReuseIdentifier,
			 Constants.cardInputTextColorInvalidCellReuseIdentifier,
			 Constants.cardInputTextColorPlaceholderCellReuseIdentifier,
			 Constants.cardInputDescriptionTextColorCellReuseIdentifier,
			 Constants.cardInputSaveCardSwitchOffTintColorCellReuseIdentifier,
			 Constants.cardInputSaveCardSwitchOnTintColorCellReuseIdentifier,
			 Constants.cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier,
			 Constants.cardInputScanIconFrameTintColorCellReuseIdentifier,
			 Constants.cardInputScanIconTintColorCellReuseIdentifier,
			 Constants.tapButtonDisabledBackgroundColorCellReuseIdentifier,
			 Constants.tapButtonEnabledBackgroundColorCellReuseIdentifier,
			 Constants.tapButtonHighlightedBackgroundColorCellReuseIdentifier,
			 Constants.tapButtonDisabledTextColorCellReuseIdentifier,
			 Constants.tapButtonEnabledTextColorCellReuseIdentifier,
			 Constants.tapButtonHighlightedTextColorCellReuseIdentifier,
			 Constants.backgroundColorCellReuseIdentifier:
			
			self.showColorSelectionViewController(with: reuseIdentifier)
			
		case Constants.customerCellReuseIdentifier:
			
			self.showCustomersListViewController()
			
		case Constants.headerFontCellReuseIdentifier,
			 Constants.headerCancelFontCellReuseIdentifier,
			 Constants.cardInputFontCellReuseIdentifier,
			 Constants.cardInputDescriptionFontCellReuseIdentifier,
			 Constants.tapButtonFontCellReuseIdentifier:
			
			self.showFontSelectionViewController(with: reuseIdentifier)
			
		default:
			
            break
        }
    }
    
    // MARK: - Fileprivate -
	
	fileprivate class DestinationsTableViewHandler: NSObject {
		
		fileprivate let settings: Settings
		fileprivate unowned let settingsController: SettingsTableViewController
		
		fileprivate init(settings: Settings, settingsController: SettingsTableViewController) {
			
			self.settings = settings
			self.settingsController = settingsController
		}
	}
	
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
		
		fileprivate static let sdkLanguageCelReuseIdentifier							= "sdk_language_cell"
		
        fileprivate static let sdkModeCellReuseIdentifier          						= "sdk_mode_cell"
        fileprivate static let transactionModeCellReuseIdentifier   					= "transaction_mode_cell"
        fileprivate static let currencyCellReuseIdentifier          					= "currency_cell"
        fileprivate static let customerCellReuseIdentifier          					= "customer_cell"
		fileprivate static let destinationsListCellReuseIdentifier						= "destinations_list_cell"
        fileprivate static let taxListCellReuseIdentifier           					= "tax_list_cell"
        fileprivate static let shippingListCellReuseIdentifier      					= "shipping_list_cell"
		
		fileprivate static let appearanceModeCellReuseIdentifier						= "appearance_mode_cell"
		fileprivate static let headerFontCellReuseIdentifier							= "header_font_cell"
		fileprivate static let headerTextColorCellReuseIdentifier						= "header_text_color_cell"
		fileprivate static let headerBackgroundColorCellReuseIdentifier					= "header_background_color_cell"
		fileprivate static let headerCancelFontCellReuseIdentifier						= "header_cancel_font_cell"
		fileprivate static let headerCancelNormalColorCellReuseIdentifier				= "header_cancel_normal_color_cell"
		fileprivate static let headerCancelHighlightedColorCellReuseIdentifier			= "header_cancel_highlighted_color_cell"
		fileprivate static let cardInputFontCellReuseIdentifier							= "card_input_font_cell"
		fileprivate static let cardInputTextColorCellReuseIdentifier					= "card_input_color_valid_cell"
		fileprivate static let cardInputTextColorInvalidCellReuseIdentifier				= "card_input_color_invalid_cell"
		fileprivate static let cardInputTextColorPlaceholderCellReuseIdentifier			= "card_input_color_placeholder_cell"
		fileprivate static let cardInputDescriptionFontCellReuseIdentifier				= "card_input_description_font_cell"
		fileprivate static let cardInputDescriptionTextColorCellReuseIdentifier			= "card_input_description_color_cell"
		fileprivate static let cardInputSaveCardSwitchOffTintColorCellReuseIdentifier	= "card_input_save_card_switch_off_tint_cell"
		fileprivate static let cardInputSaveCardSwitchOnTintColorCellReuseIdentifier	= "card_input_save_card_switch_on_tint_cell"
		fileprivate static let cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier	= "card_input_save_card_switch_thumb_tint_cell"
		fileprivate static let cardInputScanIconFrameTintColorCellReuseIdentifier		= "card_input_scan_icon_frame_tint_cell"
		fileprivate static let cardInputScanIconTintColorCellReuseIdentifier			= "card_input_scan_icon_tint_cell"
		fileprivate static let tapButtonDisabledBackgroundColorCellReuseIdentifier		= "tap_button_disabled_background_color_cell"
		fileprivate static let tapButtonEnabledBackgroundColorCellReuseIdentifier		= "tap_button_enabled_background_color_cell"
		fileprivate static let tapButtonHighlightedBackgroundColorCellReuseIdentifier	= "tap_button_highlighted_background_color_cell"
		fileprivate static let tapButtonFontCellReuseIdentifier							= "tap_button_font_cell"
		fileprivate static let tapButtonDisabledTextColorCellReuseIdentifier			= "tap_button_disabled_text_color_cell"
		fileprivate static let tapButtonEnabledTextColorCellReuseIdentifier				= "tap_button_enabled_text_color_cell"
		fileprivate static let tapButtonHighlightedTextColorCellReuseIdentifier			= "tap_button_highlighted_text_color_cell"
		fileprivate static let backgroundColorCellReuseIdentifier						= "background_color_cell"
		fileprivate static let backgroundBlurStyleCellReuseIdentifier					= "background_blur_style_cell"
		
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
	
	@IBOutlet private weak var sdkLanguageValueLabel: UILabel?
	
    @IBOutlet private weak var sdkModeValueLabel: UILabel?
    @IBOutlet private weak var transactionModeValueLabel: UILabel?
    @IBOutlet private weak var currencyValueLabel: UILabel?
    @IBOutlet private weak var customerNameLabel: UILabel?
	@IBOutlet private weak var threeDSecureSwitch: UISwitch?
	@IBOutlet private weak var saveCardMultipleTimesSwitch: UISwitch?
	
	@IBOutlet private weak var destinationsTableView: UITableView? {
		
		didSet {
			
			self.destinationsTableView?.dataSource = self.destinationTableViewHandler
			self.destinationsTableView?.delegate = self.destinationTableViewHandler
		}
	}
	
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
	
	@IBOutlet private weak var appearanceModeValueLabel: UILabel?
	@IBOutlet private weak var showsStatusPopupSwitch: UISwitch?
	
	@IBOutlet private weak var headerFontValueLabel: UILabel?
	@IBOutlet private weak var headerTextColorValueLabel: UILabel?
	@IBOutlet private weak var headerBackgroundColorValueLabel: UILabel?
	@IBOutlet private weak var headerCancelFontValueLabel: UILabel?
	@IBOutlet private weak var headerCancelNormalTextColorValueLabel: UILabel?
	@IBOutlet private weak var headerCancelHighlightedTextColorValueLabel: UILabel?
	
	@IBOutlet private weak var cardInputFontValueLabel: UILabel?
	@IBOutlet private weak var cardInputTextColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputInvalidTextColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputPlaceholderTextColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputDescriptionFontValueLabel: UILabel?
	@IBOutlet private weak var cardInputDescriptionTextColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputSaveCardSwitchOffTintColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputSaveCardSwitchOnTintColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputSaveCardSwitchThumbTintColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputScanIconFrameTintColorValueLabel: UILabel?
	@IBOutlet private weak var cardInputScanIconTintColorValueLabel: UILabel?
	
	@IBOutlet private weak var tapButtonDisabledBackgroundColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonEnabledBackgroundColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonHighlightedBackgroundColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonTitleFontValueLabel: UILabel?
	@IBOutlet private weak var tapButtonDisabledTitleColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonEnabledTitleColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonHighlightedTitleColorValueLabel: UILabel?
	@IBOutlet private weak var tapButtonHeightValueLabel: UILabel?
	@IBOutlet private weak var tapButtonHeightStepper: UIStepper?
	@IBOutlet private weak var tapButtonCornerRadiusValueLabel: UILabel?
	@IBOutlet private weak var tapButtonCornerRadiusStepper: UIStepper?
	@IBOutlet private weak var tapButtonTopInsetValueLabel: UILabel?
	@IBOutlet private weak var tapButtonTopInsetStepper: UIStepper?
	@IBOutlet private weak var tapButtonLeadingInsetValueLabel: UILabel?
	@IBOutlet private weak var tapButtonLeadingInsetStepper: UIStepper?
	@IBOutlet private weak var tapButtonTrailingInsetValueLabel: UILabel?
	@IBOutlet private weak var tapButtonTrailingInsetStepper: UIStepper?
	@IBOutlet private weak var tapButtonBottomInsetValueLabel: UILabel?
	@IBOutlet private weak var tapButtonBottomInsetStepper: UIStepper?
	@IBOutlet private weak var tapButtonLoaderVisibleSwitch: UISwitch?
	@IBOutlet private weak var tapButtonSecurityIconVisibleSwitch: UISwitch?
	@IBOutlet private weak var backgroundColorValueLabel: UILabel?
	@IBOutlet private weak var backgroundBlurStyleValueLabel: UILabel?
	@IBOutlet private weak var backgroundBlurProgressValueLabel: UILabel?
	@IBOutlet private weak var backgroundBlurProgressStepper: UIStepper?
	
    private var currentSettings: Settings? {
        
        didSet {
            
            self.updateWithCurrentSettings()
        }
    }
    
    private var selectedCellReuseIdentifier: String?
	
	private lazy var destinationTableViewHandler: DestinationsTableViewHandler = DestinationsTableViewHandler(settings: self.currentSettings ?? .default, settingsController: self)
    private lazy var shippingTableViewHandler: ShippingTableViewHandler = ShippingTableViewHandler(settings: self.currentSettings ?? .default, settingsController: self)
    private lazy var taxesTableViewHandler: TaxesTableViewHandler = TaxesTableViewHandler(settings: self.currentSettings ?? .default, settingsController: self)
	
	private var selectedDestination: Destination?
    private var selectedTax: Tax?
    private var selectedShipping: Shipping?
    
    // MARK: Methods
    
    private func showCaseSelectionViewController(with reuseIdentifier: String) {
        
        self.selectedCellReuseIdentifier = reuseIdentifier
        self.show(CaseSelectionTableViewController.self)
    }
	
	private func showColorSelectionViewController(with reuseIdentifier: String) {
		
		self.selectedCellReuseIdentifier = reuseIdentifier
		self.show(ColorSelectionTableViewController.self)
	}
	
	private func showFontSelectionViewController(with reuseIdentifier: String) {
		
		self.selectedCellReuseIdentifier = reuseIdentifier
		self.show(FontSelectionTableViewController.self)
	}
	
    private func showCustomersListViewController() {
        
        self.show(CustomersListViewController.self)
    }
    
    private func updateWithCurrentSettings() {
		
		// Common
		
		self.sdkLanguageValueLabel?.text					= self.currentSettings?.sdkLanguage.description
		
		// Data source
		
		self.sdkModeValueLabel?.text            			= self.currentSettings?.sdkMode.description
        self.transactionModeValueLabel?.text    			= self.currentSettings?.transactionMode.description
        self.currencyValueLabel?.text           			= self.currentSettings?.currency.localizedSymbol
		self.threeDSecureSwitch?.isOn						= self.currentSettings?.isThreeDSecure ?? Settings.default.isThreeDSecure
		self.saveCardMultipleTimesSwitch?.isOn				= self.currentSettings?.canSaveSameCardMultipleTimes ?? Settings.default.canSaveSameCardMultipleTimes
		
		if let name = self.currentSettings?.customer?.customer.firstName?.trimmingCharacters(in: .whitespacesAndNewlines),
			let surname = self.currentSettings?.customer?.customer.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) {
			
			self.customerNameLabel?.text = name + " " + surname
		}
		else {
			
			self.customerNameLabel?.text = nil
		}
		
		// Appearance
		
		self.appearanceModeValueLabel?.text					= self.currentSettings?.appearanceMode.description
		self.showsStatusPopupSwitch?.isOn					= self.currentSettings?.showsStatusPopup ?? Settings.default.showsStatusPopup
		
		// Background
		
		self.backgroundColorValueLabel?.text	= self.currentSettings?.backgroundColor.description
		if let set = self.currentSettings { self.backgroundColorValueLabel?.textColor = set.backgroundColor.asUIColor }
		
		self.backgroundBlurStyleValueLabel?.text = self.currentSettings?.backgroundBlurStyle.description
		
		let backgroundBlurProgress = self.currentSettings?.backgroundBlurProgress ?? Settings.default.backgroundBlurProgress
		self.backgroundBlurProgressValueLabel?.text = String(format: "%.02f", backgroundBlurProgress)
		self.backgroundBlurProgressStepper?.value = Double(backgroundBlurProgress)
		
		// Header
		
		self.headerFontValueLabel?.text						= self.currentSettings?.headerFont
		if let set = self.currentSettings, let font = UIFont(name: set.headerFont, size: 17.0) {
			
			self.headerFontValueLabel?.font			= font
			self.headerTextColorValueLabel?.font	= font
		}
		
		self.headerTextColorValueLabel?.text = self.currentSettings?.headerTextColor.description
		if let set = self.currentSettings { self.headerTextColorValueLabel?.textColor = set.headerTextColor.asUIColor }
		
		self.headerBackgroundColorValueLabel?.text = self.currentSettings?.headerBackgroundColor.description
		if let set = self.currentSettings { self.headerBackgroundColorValueLabel?.textColor = set.headerBackgroundColor.asUIColor }
		
		self.headerCancelFontValueLabel?.text = self.currentSettings?.headerCancelFont
		if let set = self.currentSettings, let font = UIFont(name: set.headerCancelFont, size: 17.0) {
			
			self.headerCancelFontValueLabel?.font					= font
			self.headerCancelNormalTextColorValueLabel?.font		= font
			self.headerCancelHighlightedTextColorValueLabel?.font	= font
		}
		
		self.headerCancelNormalTextColorValueLabel?.text = self.currentSettings?.headerCancelNormalTextColor.description
		if let set = self.currentSettings { self.headerCancelNormalTextColorValueLabel?.textColor = set.headerCancelNormalTextColor.asUIColor }
		
		self.headerCancelHighlightedTextColorValueLabel?.text = self.currentSettings?.headerCancelHighlightedTextColor.description
		if let set = self.currentSettings { self.headerCancelHighlightedTextColorValueLabel?.textColor = set.headerCancelHighlightedTextColor.asUIColor }
		
		// Card Input
		
		self.cardInputFontValueLabel?.text					= self.currentSettings?.cardInputFont
		
		if let set = self.currentSettings, let font = UIFont(name: set.cardInputFont, size: 17.0) {
			
			self.cardInputFontValueLabel?.font					= font
			self.cardInputTextColorValueLabel?.font				= font
			self.cardInputInvalidTextColorValueLabel?.font		= font
			self.cardInputPlaceholderTextColorValueLabel?.font	= font
		}
		
		self.cardInputTextColorValueLabel?.text				= self.currentSettings?.cardInputTextColor.description
		if let set = self.currentSettings { self.cardInputTextColorValueLabel?.textColor = set.cardInputTextColor.asUIColor }
		self.cardInputInvalidTextColorValueLabel?.text		= self.currentSettings?.cardInputInvalidTextColor.description
		if let set = self.currentSettings { self.cardInputInvalidTextColorValueLabel?.textColor = set.cardInputInvalidTextColor.asUIColor }
		self.cardInputPlaceholderTextColorValueLabel?.text	= self.currentSettings?.cardInputPlaceholderTextColor.description
		if let set = self.currentSettings { self.cardInputPlaceholderTextColorValueLabel?.textColor = set.cardInputPlaceholderTextColor.asUIColor }
		self.cardInputDescriptionFontValueLabel?.text		= self.currentSettings?.cardInputDescriptionFont
		
		if let set = self.currentSettings, let font = UIFont(name: set.cardInputDescriptionFont, size: 17.0) {
			
			self.cardInputDescriptionFontValueLabel?.font		= font
			self.cardInputDescriptionTextColorValueLabel?.font	= font
		}
		
		self.cardInputDescriptionTextColorValueLabel?.text	= self.currentSettings?.cardInputDescriptionTextColor.description
		if let set = self.currentSettings { self.cardInputDescriptionTextColorValueLabel?.textColor = set.cardInputDescriptionTextColor.asUIColor }
		
		self.cardInputSaveCardSwitchOffTintColorValueLabel?.text = self.currentSettings?.cardInputSaveCardSwitchOffTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchOffTintColorValueLabel?.textColor = set.cardInputSaveCardSwitchOffTintColor.asUIColor }
		self.cardInputSaveCardSwitchOnTintColorValueLabel?.text = self.currentSettings?.cardInputSaveCardSwitchOnTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchOnTintColorValueLabel?.textColor = set.cardInputSaveCardSwitchOnTintColor.asUIColor }
		self.cardInputSaveCardSwitchThumbTintColorValueLabel?.text = self.currentSettings?.cardInputSaveCardSwitchThumbTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchThumbTintColorValueLabel?.textColor = set.cardInputSaveCardSwitchThumbTintColor.asUIColor }
		
		self.cardInputScanIconFrameTintColorValueLabel?.text = self.currentSettings?.cardInputScanIconFrameTintColor.description
		if let set = self.currentSettings { self.cardInputScanIconFrameTintColorValueLabel?.textColor = set.cardInputScanIconFrameTintColor.asUIColor }
		self.cardInputScanIconTintColorValueLabel?.text = self.currentSettings?.cardInputScanIconTintColor?.description
		if let set = self.currentSettings { self.cardInputScanIconTintColorValueLabel?.textColor = set.cardInputScanIconTintColor?.asUIColor }
		
		self.tapButtonDisabledBackgroundColorValueLabel?.text = self.currentSettings?.tapButtonDisabledBackgroundColor?.description
		if let set = self.currentSettings, let color = set.tapButtonDisabledBackgroundColor { self.tapButtonDisabledBackgroundColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonEnabledBackgroundColorValueLabel?.text = self.currentSettings?.tapButtonEnabledBackgroundColor?.description
		if let set = self.currentSettings, let color = set.tapButtonEnabledBackgroundColor { self.tapButtonEnabledBackgroundColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonHighlightedBackgroundColorValueLabel?.text = self.currentSettings?.tapButtonHighlightedBackgroundColor?.description
		if let set = self.currentSettings, let color = set.tapButtonHighlightedBackgroundColor { self.tapButtonHighlightedBackgroundColorValueLabel?.textColor = color.asUIColor }
		
		self.tapButtonTitleFontValueLabel?.text = self.currentSettings?.tapButtonFont
		if let set = self.currentSettings, let font = UIFont(name: set.tapButtonFont, size: 17.0) {
			
			self.tapButtonTitleFontValueLabel?.font				= font
			self.tapButtonDisabledTitleColorValueLabel?.font	= font
			self.tapButtonEnabledTitleColorValueLabel?.font		= font
			self.tapButtonHighlightedTitleColorValueLabel?.font	= font
		}
		
		self.tapButtonDisabledTitleColorValueLabel?.text = self.currentSettings?.tapButtonDisabledTextColor?.description
		if let set = self.currentSettings, let color = set.tapButtonDisabledTextColor { self.tapButtonDisabledTitleColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonEnabledTitleColorValueLabel?.text = self.currentSettings?.tapButtonEnabledTextColor?.description
		if let set = self.currentSettings, let color = set.tapButtonEnabledTextColor { self.tapButtonEnabledTitleColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonHighlightedTitleColorValueLabel?.text = self.currentSettings?.tapButtonHighlightedTextColor?.description
		if let set = self.currentSettings, let color = set.tapButtonHighlightedTextColor { self.tapButtonHighlightedTitleColorValueLabel?.textColor = color.asUIColor }
		
		let tapButtonHeight = self.currentSettings?.tapButtonHeight ?? Settings.default.tapButtonHeight
		self.tapButtonHeightValueLabel?.text = "\(tapButtonHeight)"
		self.tapButtonHeightStepper?.value = Double(tapButtonHeight)
		
		let tapButtonCornerRadius = self.currentSettings?.tapButtonCornerRadius ?? Settings.default.tapButtonCornerRadius
		self.tapButtonCornerRadiusValueLabel?.text = "\(tapButtonCornerRadius)"
		self.tapButtonCornerRadiusStepper?.value = Double(tapButtonCornerRadius)
		
		let tapButtonTopInset = self.currentSettings?.tapButtonEdgeInsets.top ?? Settings.default.tapButtonEdgeInsets.top
		self.tapButtonTopInsetValueLabel?.text = "\(tapButtonTopInset)"
		self.tapButtonTopInsetStepper?.value = Double(tapButtonTopInset)
		
		let tapButtonLeadingInset = self.currentSettings?.tapButtonEdgeInsets.left ?? Settings.default.tapButtonEdgeInsets.left
		self.tapButtonLeadingInsetValueLabel?.text = "\(tapButtonLeadingInset)"
		self.tapButtonLeadingInsetStepper?.value = Double(tapButtonLeadingInset)
		
		let tapButtonTrailingInset = self.currentSettings?.tapButtonEdgeInsets.right ?? Settings.default.tapButtonEdgeInsets.right
		self.tapButtonTrailingInsetValueLabel?.text = "\(tapButtonTrailingInset)"
		self.tapButtonTrailingInsetStepper?.value = Double(tapButtonTrailingInset)
		
		let tapButtonBottomInset = self.currentSettings?.tapButtonEdgeInsets.bottom ?? Settings.default.tapButtonEdgeInsets.bottom
		self.tapButtonBottomInsetValueLabel?.text = "\(tapButtonBottomInset)"
		self.tapButtonBottomInsetStepper?.value = Double(tapButtonBottomInset)
		
		self.tapButtonLoaderVisibleSwitch?.isOn = self.currentSettings?.isTapButtonLoaderVisible ?? Settings.default.isTapButtonLoaderVisible
		self.tapButtonSecurityIconVisibleSwitch?.isOn = self.currentSettings?.isTapButtonSecurityIconVisible ?? Settings.default.isTapButtonSecurityIconVisible
    }
	
	@IBAction private func threeDSecureSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.isThreeDSecure = self.threeDSecureSwitch?.isOn ?? Settings.default.isThreeDSecure
	}
	
	@IBAction private func saveCardMultipleTimesSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.canSaveSameCardMultipleTimes = self.saveCardMultipleTimesSwitch?.isOn ?? Settings.default.canSaveSameCardMultipleTimes
	}
	
	@IBAction private func showsStatusPopupSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.showsStatusPopup = self.showsStatusPopupSwitch?.isOn ?? Settings.default.showsStatusPopup
	}
	
	@IBAction private func tapButtonHeightStepperValueChanged(_ sender: Any) {
		
		var height: CGFloat
		
		if let value = self.tapButtonHeightStepper?.value {
			
			height = CGFloat(value)
		}
		else {
			
			height = Settings.default.tapButtonHeight
		}
		
		self.currentSettings?.tapButtonHeight = height
		self.tapButtonHeightValueLabel?.text = "\(height)"
	}
	
	@IBAction private func tapButtonCornerRadiusStepperValueChanged(_ sender: Any) {
		
		var radius: CGFloat
		
		if let value = self.tapButtonCornerRadiusStepper?.value {
			
			radius = CGFloat(value)
		}
		else {
			
			radius = Settings.default.tapButtonCornerRadius
		}
		
		self.currentSettings?.tapButtonCornerRadius = radius
		self.tapButtonCornerRadiusValueLabel?.text = "\(radius)"
	}
	
	@IBAction private func tapButtonTopInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonTopInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.tapButtonEdgeInsets.top
		}
		
		self.currentSettings?.tapButtonEdgeInsets.top = inset
		self.tapButtonTopInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonLeadingInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonLeadingInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.tapButtonEdgeInsets.left
		}
		
		self.currentSettings?.tapButtonEdgeInsets.left = inset
		self.tapButtonLeadingInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonTrailingInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonTrailingInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.tapButtonEdgeInsets.right
		}
		
		self.currentSettings?.tapButtonEdgeInsets.right = inset
		self.tapButtonTrailingInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonBottomInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonBottomInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.tapButtonEdgeInsets.bottom
		}
		
		self.currentSettings?.tapButtonEdgeInsets.bottom = inset
		self.tapButtonBottomInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonLoaderVisibleSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.isTapButtonLoaderVisible = self.tapButtonLoaderVisibleSwitch?.isOn ?? Settings.default.isTapButtonLoaderVisible
	}
	
	@IBAction private func tapButtonSecurityIconVisibleSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.isTapButtonSecurityIconVisible = self.tapButtonSecurityIconVisibleSwitch?.isOn ?? Settings.default.isTapButtonSecurityIconVisible
	}
	
	@IBAction private func backgroundBlurProgressStepperValueChanged(_ sender: Any) {
		
		var progress: CGFloat
		
		if let value = self.backgroundBlurProgressStepper?.value {
			
			progress = CGFloat(value)
		}
		else {
			
			progress = Settings.default.backgroundBlurProgress
		}
		
		self.currentSettings?.backgroundBlurProgress = progress
		self.backgroundBlurProgressValueLabel?.text = String(format: "%.2f", progress)
	}
	
	@IBAction private func addDestinationButtonTouchUpInside(_ sender: Any) {
		
		if let selectedDestinationIndexPath = self.destinationsTableView?.indexPathForSelectedRow {
			
			self.destinationsTableView?.deselectRow(at: selectedDestinationIndexPath, animated: false)
		}
		
		self.showDestinationController()
	}
	
	private func showDetails(of destination: Destination) {
		
		self.showDestinationController(with: destination)
	}
	
	private func showDestinationController(with destination: Destination? = nil) {
		
		self.selectedDestination = destination
		self.show(DestinationViewController.self)
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
		
		self.sdkLanguageValueLabel?.textAlignment							= trailing
		
		self.sdkModeValueLabel?.textAlignment								= trailing
		self.transactionModeValueLabel?.textAlignment						= trailing
		self.currencyValueLabel?.textAlignment								= trailing
		self.customerNameLabel?.textAlignment								= trailing
		
		self.appearanceModeValueLabel?.textAlignment						= trailing
		self.headerFontValueLabel?.textAlignment							= trailing
		self.headerTextColorValueLabel?.textAlignment						= trailing
		self.headerBackgroundColorValueLabel?.textAlignment					= trailing
		self.headerCancelFontValueLabel?.textAlignment						= trailing
		self.headerCancelNormalTextColorValueLabel?.textAlignment			= trailing
		self.headerCancelHighlightedTextColorValueLabel?.textAlignment		= trailing
		self.cardInputFontValueLabel?.textAlignment							= trailing
		self.cardInputTextColorValueLabel?.textAlignment					= trailing
		self.cardInputInvalidTextColorValueLabel?.textAlignment				= trailing
		self.cardInputPlaceholderTextColorValueLabel?.textAlignment			= trailing
		self.cardInputDescriptionFontValueLabel?.textAlignment				= trailing
		self.cardInputDescriptionTextColorValueLabel?.textAlignment			= trailing
		self.cardInputSaveCardSwitchOffTintColorValueLabel?.textAlignment	= trailing
		self.cardInputSaveCardSwitchOnTintColorValueLabel?.textAlignment	= trailing
		self.cardInputSaveCardSwitchThumbTintColorValueLabel?.textAlignment	= trailing
		self.cardInputScanIconFrameTintColorValueLabel?.textAlignment		= trailing
		self.cardInputScanIconTintColorValueLabel?.textAlignment			= trailing
		self.tapButtonDisabledBackgroundColorValueLabel?.textAlignment		= trailing
		self.tapButtonEnabledBackgroundColorValueLabel?.textAlignment		= trailing
		self.tapButtonHighlightedBackgroundColorValueLabel?.textAlignment	= trailing
		self.tapButtonTitleFontValueLabel?.textAlignment					= trailing
		self.tapButtonDisabledTitleColorValueLabel?.textAlignment			= trailing
		self.tapButtonEnabledTitleColorValueLabel?.textAlignment			= trailing
		self.tapButtonHighlightedTitleColorValueLabel?.textAlignment		= trailing
		self.tapButtonCornerRadiusValueLabel?.textAlignment					= trailing
		self.backgroundColorValueLabel?.textAlignment						= trailing
		self.backgroundBlurStyleValueLabel?.textAlignment					= trailing
		self.backgroundBlurProgressValueLabel?.textAlignment				= trailing
	}
}

// MARK: - SeguePresenter
extension SettingsTableViewController: SeguePresenter {}

// MARK: - DestinationViewControllerDelegate
extension SettingsTableViewController: DestinationViewControllerDelegate {
	
	internal func destinationViewController(_ controller: DestinationViewController, didFinishWith destination: Destination) {
		
		if let nonnullSelectedDestination = self.selectedDestination {
			
			if let index = self.currentSettings?.destinations.index(of: nonnullSelectedDestination) {
				
				self.currentSettings?.destinations.remove(at: index)
				self.currentSettings?.destinations.insert(destination, at: index)
			}
			else {
				
				self.currentSettings?.destinations.append(destination)
			}
		}
		else {
			
			self.currentSettings?.destinations.append(destination)
		}
		
		self.destinationsTableView?.reloadData()
		
		self.tableView.beginUpdates()
		self.tableView.endUpdates()
	}
}

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
			
		case Constants.headerTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.headerTextColor = color
			}
			
		case Constants.headerBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.headerBackgroundColor = color
			}

		case Constants.headerCancelNormalColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.headerCancelNormalTextColor = color
			}

		case Constants.headerCancelHighlightedColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.headerCancelHighlightedTextColor = color
			}

		case Constants.headerFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.headerFont = font
			}
			
		case Constants.headerCancelFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.headerCancelFont = font
			}
			
		case Constants.cardInputFontCellReuseIdentifier:
			
			if let cardInputFont = value as? String {
				
				self.currentSettings?.cardInputFont = cardInputFont
			}
			
		case Constants.cardInputDescriptionFontCellReuseIdentifier:
			
			if let cardInputDescriptionFont = value as? String {
			
				self.currentSettings?.cardInputDescriptionFont = cardInputDescriptionFont
			}
			
		case Constants.cardInputTextColorCellReuseIdentifier:
			
			if let cardInputTextColor = value as? Color {
				
				self.currentSettings?.cardInputTextColor = cardInputTextColor
			}
			
		case Constants.cardInputTextColorInvalidCellReuseIdentifier:
			
			if let cardInputInvalidTextColor = value as? Color {
				
				self.currentSettings?.cardInputInvalidTextColor = cardInputInvalidTextColor
			}
			
		case Constants.cardInputTextColorPlaceholderCellReuseIdentifier:
			
			if let cardInputPlaceholderTextColor = value as? Color {
				
				self.currentSettings?.cardInputPlaceholderTextColor = cardInputPlaceholderTextColor
			}
			
		case Constants.cardInputDescriptionTextColorCellReuseIdentifier:
			
			if let cardInputDescriptionTextColor = value as? Color {
				
				self.currentSettings?.cardInputDescriptionTextColor = cardInputDescriptionTextColor
			}
			
		case Constants.cardInputSaveCardSwitchOffTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchOffTintColor = value as? Color {
				
				self.currentSettings?.cardInputSaveCardSwitchOffTintColor = cardInputSaveCardSwitchOffTintColor
			}
			
		case Constants.cardInputSaveCardSwitchOnTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchOnTintColor = value as? Color {
				
				self.currentSettings?.cardInputSaveCardSwitchOnTintColor = cardInputSaveCardSwitchOnTintColor
			}
			
		case Constants.cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchThumbTintColor = value as? Color {
				
				self.currentSettings?.cardInputSaveCardSwitchThumbTintColor = cardInputSaveCardSwitchThumbTintColor
			}
			
		case Constants.cardInputScanIconFrameTintColorCellReuseIdentifier:
			
			if let cardInputScanIconFrameTintColor = value as? Color {
				
				self.currentSettings?.cardInputScanIconFrameTintColor = cardInputScanIconFrameTintColor
			}
			
		case Constants.cardInputScanIconTintColorCellReuseIdentifier:
			
			if let cardInputScanIconTintColor = value as? Color {
				
				self.currentSettings?.cardInputScanIconTintColor = cardInputScanIconTintColor
			}
			
		case Constants.tapButtonDisabledBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonDisabledBackgroundColor = color
			}
			
		case Constants.tapButtonEnabledBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonEnabledBackgroundColor = color
			}
			
		case Constants.tapButtonHighlightedBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonHighlightedBackgroundColor = color
			}
			
		case Constants.tapButtonFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.tapButtonFont = font
			}
			
		case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonDisabledTextColor = color
			}
			
		case Constants.tapButtonEnabledTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonEnabledTextColor = color
			}
			
		case Constants.tapButtonHighlightedTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.tapButtonHighlightedTextColor = color
			}
			
		case Constants.backgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.backgroundColor = color
			}
			
		case Constants.backgroundBlurStyleCellReuseIdentifier:
			
			if let style = value as? UIBlurEffect.Style {
				
				self.currentSettings?.backgroundBlurStyle = style
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
extension SettingsTableViewController.DestinationsTableViewHandler: UITableViewDataSource {
	
	private var destinations: [Destination] {
		
		return self.settings.destinations
	}
	
	fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.destinations.count
	}
	
	fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DestinationTableViewCell.tap_className) as? DestinationTableViewCell else {
			
			fatalError("Failed to load \(DestinationTableViewCell.tap_className) from storyboard.")
		}
		
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController.DestinationsTableViewHandler: UITableViewDelegate {
	
	fileprivate func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let destinationCell = cell as? DestinationTableViewCell else {
			
			fatalError("Somehow cell class is wrong.")
		}
		
		let destination = self.destinations[indexPath.row]
		
		destinationCell.setIdentifier(destination.identifier, amount: "\(destination.amount)", currency: destination.currency.isoCode)
	}
	
	fileprivate func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		let destination = self.destinations[indexPath.row]
		self.settingsController.showDetails(of: destination)
	}
	
	fileprivate func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
			
			self.settings.destinations.remove(at: cellIndexPath.row)
			tableView.deleteRows(at: [cellIndexPath], with: .automatic)
			
			self.settingsController.tableView.beginUpdates()
			self.settingsController.tableView.endUpdates()
		}
		
		return [deleteAction]
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
