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
import class	goSellSDK.GoSellSDK
import enum		goSellSDK.SDKAppearanceMode
import enum     goSellSDK.SDKMode
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import class	goSellSDK.TapBlurStyle
import enum     goSellSDK.TransactionMode
import enum     goSellSDK.PaymentType
import class    ObjectiveC.NSObject.NSObject
import enum		UIKit.NSText.NSTextAlignment
import class	UIKit.UIApplication.UIApplication
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

#if !swift(>=4.2)
import var		UIKit.UITableView.UITableViewAutomaticDimension
#endif

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
            customersListController.mode                = self.currentSettings?.dataSource.sdkMode ?? .sandbox
            customersListController.selectedCustomer    = self.currentSettings?.dataSource.customer
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
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.headerTextColor
				
			case Constants.headerBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.headerBackgroundColor
				
			case Constants.headerCancelNormalColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Cancel Normal Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.headerCancelNormalTextColor
				
			case Constants.headerCancelHighlightedColorCellReuseIdentifier:
				
				colorSelectionController.title = "Header Cancel Highlighted Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.headerCancelHighlightedTextColor
				
			case Constants.cardInputTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Text Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputTextColor
				
			case Constants.cardInputTextColorInvalidCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Invalid Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputInvalidTextColor
				
			case Constants.cardInputTextColorPlaceholderCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Placeholder Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputPlaceholderTextColor
				
			case Constants.cardInputDescriptionTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Card Input Description Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputDescriptionTextColor
				
			case Constants.cardInputSaveCardSwitchOffTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch Off Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputSaveCardSwitchOffTintColor
				
			case Constants.cardInputSaveCardSwitchOnTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch On Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputSaveCardSwitchOnTintColor
				
			case Constants.cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Save Card Switch Thumb Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputSaveCardSwitchThumbTintColor
				
			case Constants.cardInputScanIconFrameTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Scan Icon Frame Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputScanIconFrameTintColor
				
			case Constants.cardInputScanIconTintColorCellReuseIdentifier:
				
				colorSelectionController.title = "Scan Icon Tint"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputScanIconTintColor
				
			case Constants.tapButtonDisabledBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button disabled background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonDisabledBackgroundColor
				
			case Constants.tapButtonEnabledBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button enabled background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonEnabledBackgroundColor
				
			case Constants.tapButtonHighlightedBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button highlighted background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonDisabledBackgroundColor
				
			case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button disabled text color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonDisabledTextColor
				
			case Constants.tapButtonEnabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button enabled text color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonEnabledTextColor
				
			case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
				
				colorSelectionController.title = "Pay/Save Button highlighted text color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonHighlightedTextColor
				
			case Constants.backgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.backgroundColor
				
			case Constants.contentBackgroundColorCellReuseIdentifier:
				
				colorSelectionController.title = "Content Background Color"
				colorSelectionController.preselectedValue = self.currentSettings?.appearance.contentBackgroundColor
				
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
				fontSelectionController.preselectedValue = self.currentSettings?.appearance.headerFont
				
			case Constants.headerCancelFontCellReuseIdentifier:
				
				fontSelectionController.title = "Header Cancel Button Font"
				fontSelectionController.preselectedValue = self.currentSettings?.appearance.headerCancelFont
				
			case Constants.cardInputFontCellReuseIdentifier:
				
				fontSelectionController.title = "Card Input Font"
				fontSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputFont
				
			case Constants.cardInputDescriptionFontCellReuseIdentifier:
				
				fontSelectionController.title = "Card Input Description Font"
				fontSelectionController.preselectedValue = self.currentSettings?.appearance.cardInputDescriptionFont
				
			case Constants.tapButtonFontCellReuseIdentifier:
				
				fontSelectionController.title = "Pay/Save Button Font"
				fontSelectionController.preselectedValue = self.currentSettings?.appearance.tapButtonFont
				
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
				caseSelectionController.preselectedValue = self.currentSettings?.global.sdkLanguage
				
			case Constants.sdkModeCellReuseIdentifier:
				
				caseSelectionController.title = "SDK Mode"
				caseSelectionController.allValues = SDKMode.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.dataSource.sdkMode
				
			case Constants.appearanceModeCellReuseIdentifier:
				
				caseSelectionController.title = "Appearance Mode"
				caseSelectionController.allValues = SDKAppearanceMode.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.appearance.appearanceMode
				
			case Constants.transactionModeCellReuseIdentifier:
				
				caseSelectionController.title = "Transaction Mode"
				caseSelectionController.allValues = TransactionMode.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.dataSource.transactionMode
				
			case Constants.currencyCellReuseIdentifier:
				
				caseSelectionController.title = "Currency"
				caseSelectionController.allValues = Currency.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.dataSource.currency
				
			case Constants.backgroundBlurStyleCellReuseIdentifier:
				
				caseSelectionController.title = "Background Blur Style"
				caseSelectionController.allValues = TapBlurStyle.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.appearance.backgroundBlurStyle
				
			case Constants.paymentTypeCellReuseIdentifier:
					
				caseSelectionController.title = "Payment Type"
				caseSelectionController.allValues = PaymentType.allCases
				caseSelectionController.preselectedValue = self.currentSettings?.dataSource.paymentType
					
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
			
			#if swift(>=4.2)
            return UITableView.automaticDimension
			#else
			return UITableViewAutomaticDimension
			#endif
        }
        
        switch reuseIdentifier {
			
		case Constants.destinationsListCellReuseIdentifier:
			
			return max(65.0 * CGFloat( self.currentSettings?.dataSource.destinations.count ?? 0 ), 1.0)
			
        case Constants.taxListCellReuseIdentifier:
            
            return max(100.0 * CGFloat( self.currentSettings?.dataSource.taxes.count ?? 0 ), 1.0)
            
        case Constants.shippingListCellReuseIdentifier:
            
            return max(65.0 * CGFloat( self.currentSettings?.dataSource.shippingList.count ?? 0 ), 1.0)
            
        default:
            
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
            
		case Constants.currencyCellReuseIdentifier,
			 Constants.sdkLanguageCelReuseIdentifier,
			 Constants.sdkModeCellReuseIdentifier,
			 Constants.appearanceModeCellReuseIdentifier,
			 Constants.transactionModeCellReuseIdentifier,
			 Constants.backgroundBlurStyleCellReuseIdentifier,
			 Constants.paymentTypeCellReuseIdentifier:
			
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
			 Constants.backgroundColorCellReuseIdentifier,
			 Constants.contentBackgroundColorCellReuseIdentifier:
			
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
        fileprivate static let paymentTypeCellReuseIdentifier      						= "payment_type_cell"

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
		fileprivate static let contentBackgroundColorCellReuseIdentifier				= "content_background_color_cell"
		fileprivate static let backgroundBlurStyleCellReuseIdentifier					= "background_blur_style_cell"
		
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
	
	@IBOutlet private weak var sdkLanguageValueLabel: UILabel?
	
    @IBOutlet private weak var sdkModeValueLabel: UILabel?
    @IBOutlet private weak var transactionModeValueLabel: UILabel?
    @IBOutlet private weak var paymentTypeValueLabel: UILabel?
    @IBOutlet private weak var currencyValueLabel: UILabel?
    @IBOutlet private weak var customerNameLabel: UILabel?
	@IBOutlet private weak var threeDSecureSwitch: UISwitch?
	@IBOutlet private weak var saveCardMultipleTimesSwitch: UISwitch?
	@IBOutlet private weak var saveCardSwitchEnabledByDefaultSwitch: UISwitch?
	
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
	@IBOutlet private weak var contentBackgroundColorValueLabel: UILabel?
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
		
		self.sdkLanguageValueLabel?.text					= self.currentSettings?.global.sdkLanguage.description
		
		// Data source
		
		self.sdkModeValueLabel?.text            			= self.currentSettings?.dataSource.sdkMode.description
        self.transactionModeValueLabel?.text    			= self.currentSettings?.dataSource.transactionMode.description
        self.currencyValueLabel?.text           			= self.currentSettings?.dataSource.currency.localizedSymbol
		self.threeDSecureSwitch?.isOn						= self.currentSettings?.dataSource.isThreeDSecure ?? Settings.default.dataSource.isThreeDSecure
		self.paymentTypeValueLabel?.text            			= self.currentSettings?.dataSource.paymentType.description.capitalized
		self.saveCardMultipleTimesSwitch?.isOn				= self.currentSettings?.dataSource.canSaveSameCardMultipleTimes ?? Settings.default.dataSource.canSaveSameCardMultipleTimes
		self.saveCardSwitchEnabledByDefaultSwitch?.isOn		= self.currentSettings?.dataSource.isSaveCardSwitchToggleEnabledByDefault ?? Settings.default.dataSource.isSaveCardSwitchToggleEnabledByDefault
		
		if let name = self.currentSettings?.dataSource.customer?.customer.firstName?.trimmingCharacters(in: .whitespacesAndNewlines),
			let surname = self.currentSettings?.dataSource.customer?.customer.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) {
			
			self.customerNameLabel?.text = name + " " + surname
		}
		else {
			
			self.customerNameLabel?.text = nil
		}
		
		// Appearance
		
		self.appearanceModeValueLabel?.text					= self.currentSettings?.appearance.appearanceMode.description
		self.showsStatusPopupSwitch?.isOn					= self.currentSettings?.appearance.showsStatusPopup ?? Settings.default.appearance.showsStatusPopup
		
		// Background
		
		self.backgroundColorValueLabel?.text	= self.currentSettings?.appearance.backgroundColor.description
		if let set = self.currentSettings { self.backgroundColorValueLabel?.textColor = set.appearance.backgroundColor.asUIColor }
		
		self.contentBackgroundColorValueLabel?.text	= self.currentSettings?.appearance.contentBackgroundColor.description
		if let set = self.currentSettings { self.contentBackgroundColorValueLabel?.textColor = set.appearance.contentBackgroundColor.asUIColor }
		
		self.backgroundBlurStyleValueLabel?.text = self.currentSettings?.appearance.backgroundBlurStyle.description
		
		let backgroundBlurProgress = self.currentSettings?.appearance.backgroundBlurProgress ?? Settings.default.appearance.backgroundBlurProgress
		self.backgroundBlurProgressValueLabel?.text = String(format: "%.02f", backgroundBlurProgress)
		self.backgroundBlurProgressStepper?.value = Double(backgroundBlurProgress)
		
		// Header
		
		self.headerFontValueLabel?.text						= self.currentSettings?.appearance.headerFont
		if let set = self.currentSettings, let font = UIFont(name: set.appearance.headerFont, size: 17.0) {
			
			self.headerFontValueLabel?.font			= font
			self.headerTextColorValueLabel?.font	= font
		}
		
		self.headerTextColorValueLabel?.text = self.currentSettings?.appearance.headerTextColor.description
		if let set = self.currentSettings { self.headerTextColorValueLabel?.textColor = set.appearance.headerTextColor.asUIColor }
		
		self.headerBackgroundColorValueLabel?.text = self.currentSettings?.appearance.headerBackgroundColor.description
		if let set = self.currentSettings { self.headerBackgroundColorValueLabel?.textColor = set.appearance.headerBackgroundColor.asUIColor }
		
		self.headerCancelFontValueLabel?.text = self.currentSettings?.appearance.headerCancelFont
		if let set = self.currentSettings, let font = UIFont(name: set.appearance.headerCancelFont, size: 17.0) {
			
			self.headerCancelFontValueLabel?.font					= font
			self.headerCancelNormalTextColorValueLabel?.font		= font
			self.headerCancelHighlightedTextColorValueLabel?.font	= font
		}
		
		self.headerCancelNormalTextColorValueLabel?.text = self.currentSettings?.appearance.headerCancelNormalTextColor.description
		if let set = self.currentSettings { self.headerCancelNormalTextColorValueLabel?.textColor = set.appearance.headerCancelNormalTextColor.asUIColor }
		
		self.headerCancelHighlightedTextColorValueLabel?.text = self.currentSettings?.appearance.headerCancelHighlightedTextColor.description
		if let set = self.currentSettings { self.headerCancelHighlightedTextColorValueLabel?.textColor = set.appearance.headerCancelHighlightedTextColor.asUIColor }
		
		// Card Input
		
		self.cardInputFontValueLabel?.text					= self.currentSettings?.appearance.cardInputFont
		
		if let set = self.currentSettings, let font = UIFont(name: set.appearance.cardInputFont, size: 17.0) {
			
			self.cardInputFontValueLabel?.font					= font
			self.cardInputTextColorValueLabel?.font				= font
			self.cardInputInvalidTextColorValueLabel?.font		= font
			self.cardInputPlaceholderTextColorValueLabel?.font	= font
		}
		
		self.cardInputTextColorValueLabel?.text				= self.currentSettings?.appearance.cardInputTextColor.description
		if let set = self.currentSettings { self.cardInputTextColorValueLabel?.textColor = set.appearance.cardInputTextColor.asUIColor }
		self.cardInputInvalidTextColorValueLabel?.text		= self.currentSettings?.appearance.cardInputInvalidTextColor.description
		if let set = self.currentSettings { self.cardInputInvalidTextColorValueLabel?.textColor = set.appearance.cardInputInvalidTextColor.asUIColor }
		self.cardInputPlaceholderTextColorValueLabel?.text	= self.currentSettings?.appearance.cardInputPlaceholderTextColor.description
		if let set = self.currentSettings { self.cardInputPlaceholderTextColorValueLabel?.textColor = set.appearance.cardInputPlaceholderTextColor.asUIColor }
		self.cardInputDescriptionFontValueLabel?.text		= self.currentSettings?.appearance.cardInputDescriptionFont
		
		if let set = self.currentSettings, let font = UIFont(name: set.appearance.cardInputDescriptionFont, size: 17.0) {
			
			self.cardInputDescriptionFontValueLabel?.font		= font
			self.cardInputDescriptionTextColorValueLabel?.font	= font
		}
		
		self.cardInputDescriptionTextColorValueLabel?.text	= self.currentSettings?.appearance.cardInputDescriptionTextColor.description
		if let set = self.currentSettings { self.cardInputDescriptionTextColorValueLabel?.textColor = set.appearance.cardInputDescriptionTextColor.asUIColor }
		
		self.cardInputSaveCardSwitchOffTintColorValueLabel?.text = self.currentSettings?.appearance.cardInputSaveCardSwitchOffTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchOffTintColorValueLabel?.textColor = set.appearance.cardInputSaveCardSwitchOffTintColor.asUIColor }
		self.cardInputSaveCardSwitchOnTintColorValueLabel?.text = self.currentSettings?.appearance.cardInputSaveCardSwitchOnTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchOnTintColorValueLabel?.textColor = set.appearance.cardInputSaveCardSwitchOnTintColor.asUIColor }
		self.cardInputSaveCardSwitchThumbTintColorValueLabel?.text = self.currentSettings?.appearance.cardInputSaveCardSwitchThumbTintColor.description
		if let set = self.currentSettings { self.cardInputSaveCardSwitchThumbTintColorValueLabel?.textColor = set.appearance.cardInputSaveCardSwitchThumbTintColor.asUIColor }
		
		self.cardInputScanIconFrameTintColorValueLabel?.text = self.currentSettings?.appearance.cardInputScanIconFrameTintColor.description
		if let set = self.currentSettings { self.cardInputScanIconFrameTintColorValueLabel?.textColor = set.appearance.cardInputScanIconFrameTintColor.asUIColor }
		self.cardInputScanIconTintColorValueLabel?.text = self.currentSettings?.appearance.cardInputScanIconTintColor?.description
		if let set = self.currentSettings { self.cardInputScanIconTintColorValueLabel?.textColor = set.appearance.cardInputScanIconTintColor?.asUIColor }
		
		self.tapButtonDisabledBackgroundColorValueLabel?.text = self.currentSettings?.appearance.tapButtonDisabledBackgroundColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonDisabledBackgroundColor { self.tapButtonDisabledBackgroundColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonEnabledBackgroundColorValueLabel?.text = self.currentSettings?.appearance.tapButtonEnabledBackgroundColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonEnabledBackgroundColor { self.tapButtonEnabledBackgroundColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonHighlightedBackgroundColorValueLabel?.text = self.currentSettings?.appearance.tapButtonHighlightedBackgroundColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonHighlightedBackgroundColor { self.tapButtonHighlightedBackgroundColorValueLabel?.textColor = color.asUIColor }
		
		self.tapButtonTitleFontValueLabel?.text = self.currentSettings?.appearance.tapButtonFont
		if let set = self.currentSettings, let font = UIFont(name: set.appearance.tapButtonFont, size: 17.0) {
			
			self.tapButtonTitleFontValueLabel?.font				= font
			self.tapButtonDisabledTitleColorValueLabel?.font	= font
			self.tapButtonEnabledTitleColorValueLabel?.font		= font
			self.tapButtonHighlightedTitleColorValueLabel?.font	= font
		}
		
		self.tapButtonDisabledTitleColorValueLabel?.text = self.currentSettings?.appearance.tapButtonDisabledTextColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonDisabledTextColor { self.tapButtonDisabledTitleColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonEnabledTitleColorValueLabel?.text = self.currentSettings?.appearance.tapButtonEnabledTextColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonEnabledTextColor { self.tapButtonEnabledTitleColorValueLabel?.textColor = color.asUIColor }
		self.tapButtonHighlightedTitleColorValueLabel?.text = self.currentSettings?.appearance.tapButtonHighlightedTextColor?.description
		if let set = self.currentSettings, let color = set.appearance.tapButtonHighlightedTextColor { self.tapButtonHighlightedTitleColorValueLabel?.textColor = color.asUIColor }
		
		let tapButtonHeight = self.currentSettings?.appearance.tapButtonHeight ?? Settings.default.appearance.tapButtonHeight
		self.tapButtonHeightValueLabel?.text = "\(tapButtonHeight)"
		self.tapButtonHeightStepper?.value = Double(tapButtonHeight)
		
		let tapButtonCornerRadius = self.currentSettings?.appearance.tapButtonCornerRadius ?? Settings.default.appearance.tapButtonCornerRadius
		self.tapButtonCornerRadiusValueLabel?.text = "\(tapButtonCornerRadius)"
		self.tapButtonCornerRadiusStepper?.value = Double(tapButtonCornerRadius)
		
		let tapButtonTopInset = self.currentSettings?.appearance.tapButtonEdgeInsets.top ?? Settings.default.appearance.tapButtonEdgeInsets.top
		self.tapButtonTopInsetValueLabel?.text = "\(tapButtonTopInset)"
		self.tapButtonTopInsetStepper?.value = Double(tapButtonTopInset)
		
		let tapButtonLeadingInset = self.currentSettings?.appearance.tapButtonEdgeInsets.left ?? Settings.default.appearance.tapButtonEdgeInsets.left
		self.tapButtonLeadingInsetValueLabel?.text = "\(tapButtonLeadingInset)"
		self.tapButtonLeadingInsetStepper?.value = Double(tapButtonLeadingInset)
		
		let tapButtonTrailingInset = self.currentSettings?.appearance.tapButtonEdgeInsets.right ?? Settings.default.appearance.tapButtonEdgeInsets.right
		self.tapButtonTrailingInsetValueLabel?.text = "\(tapButtonTrailingInset)"
		self.tapButtonTrailingInsetStepper?.value = Double(tapButtonTrailingInset)
		
		let tapButtonBottomInset = self.currentSettings?.appearance.tapButtonEdgeInsets.bottom ?? Settings.default.appearance.tapButtonEdgeInsets.bottom
		self.tapButtonBottomInsetValueLabel?.text = "\(tapButtonBottomInset)"
		self.tapButtonBottomInsetStepper?.value = Double(tapButtonBottomInset)
		
		self.tapButtonLoaderVisibleSwitch?.isOn = self.currentSettings?.appearance.isTapButtonLoaderVisible ?? Settings.default.appearance.isTapButtonLoaderVisible
		self.tapButtonSecurityIconVisibleSwitch?.isOn = self.currentSettings?.appearance.isTapButtonSecurityIconVisible ?? Settings.default.appearance.isTapButtonSecurityIconVisible
    }
	
	@IBAction private func threeDSecureSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.dataSource.isThreeDSecure = self.threeDSecureSwitch?.isOn ?? Settings.default.dataSource.isThreeDSecure
	}
	
	@IBAction private func saveCardMultipleTimesSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.dataSource.canSaveSameCardMultipleTimes = self.saveCardMultipleTimesSwitch?.isOn ?? Settings.default.dataSource.canSaveSameCardMultipleTimes
	}
	
	@IBAction private func saveCardSwitchOnByDefaultValueChanged(_ sender: Any) {
		
		self.currentSettings?.dataSource.isSaveCardSwitchToggleEnabledByDefault = self.saveCardSwitchEnabledByDefaultSwitch?.isOn ?? Settings.default.dataSource.isSaveCardSwitchToggleEnabledByDefault
	}
	
	@IBAction private func showsStatusPopupSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.appearance.showsStatusPopup = self.showsStatusPopupSwitch?.isOn ?? Settings.default.appearance.showsStatusPopup
	}
	
	@IBAction private func tapButtonHeightStepperValueChanged(_ sender: Any) {
		
		var height: CGFloat
		
		if let value = self.tapButtonHeightStepper?.value {
			
			height = CGFloat(value)
		}
		else {
			
			height = Settings.default.appearance.tapButtonHeight
		}
		
		self.currentSettings?.appearance.tapButtonHeight = height
		self.tapButtonHeightValueLabel?.text = "\(height)"
	}
	
	@IBAction private func tapButtonCornerRadiusStepperValueChanged(_ sender: Any) {
		
		var radius: CGFloat
		
		if let value = self.tapButtonCornerRadiusStepper?.value {
			
			radius = CGFloat(value)
		}
		else {
			
			radius = Settings.default.appearance.tapButtonCornerRadius
		}
		
		self.currentSettings?.appearance.tapButtonCornerRadius = radius
		self.tapButtonCornerRadiusValueLabel?.text = "\(radius)"
	}
	
	@IBAction private func tapButtonTopInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonTopInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.appearance.tapButtonEdgeInsets.top
		}
		
		self.currentSettings?.appearance.tapButtonEdgeInsets.top = inset
		self.tapButtonTopInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonLeadingInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonLeadingInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.appearance.tapButtonEdgeInsets.left
		}
		
		self.currentSettings?.appearance.tapButtonEdgeInsets.left = inset
		self.tapButtonLeadingInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonTrailingInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonTrailingInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.appearance.tapButtonEdgeInsets.right
		}
		
		self.currentSettings?.appearance.tapButtonEdgeInsets.right = inset
		self.tapButtonTrailingInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonBottomInsetStepperValueChanged(_ sender: Any) {
		
		var inset: CGFloat
		
		if let value = self.tapButtonBottomInsetStepper?.value {
			
			inset = CGFloat(value)
		}
		else {
			
			inset = Settings.default.appearance.tapButtonEdgeInsets.bottom
		}
		
		self.currentSettings?.appearance.tapButtonEdgeInsets.bottom = inset
		self.tapButtonBottomInsetValueLabel?.text = "\(inset)"
	}
	
	@IBAction private func tapButtonLoaderVisibleSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.appearance.isTapButtonLoaderVisible = self.tapButtonLoaderVisibleSwitch?.isOn ?? Settings.default.appearance.isTapButtonLoaderVisible
	}
	
	@IBAction private func tapButtonSecurityIconVisibleSwitchValueChanged(_ sender: Any) {
		
		self.currentSettings?.appearance.isTapButtonSecurityIconVisible = self.tapButtonSecurityIconVisibleSwitch?.isOn ?? Settings.default.appearance.isTapButtonSecurityIconVisible
	}
	
	@IBAction private func backgroundBlurProgressStepperValueChanged(_ sender: Any) {
		
		var progress: CGFloat
		
		if let value = self.backgroundBlurProgressStepper?.value {
			
			progress = CGFloat(value)
		}
		else {
			
			progress = Settings.default.appearance.backgroundBlurProgress
		}
		
		self.currentSettings?.appearance.backgroundBlurProgress = progress
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
		self.contentBackgroundColorValueLabel?.textAlignment				= trailing
		self.backgroundBlurStyleValueLabel?.textAlignment					= trailing
		self.backgroundBlurProgressValueLabel?.textAlignment				= trailing
	}
	
	@IBAction private func restoreDataSourceDefaultsButtonTouchUpInside(_ sender: Any) {
		
		self.currentSettings?.dataSource = Settings.default.dataSource
		self.updateWithCurrentSettings()
	}
	
	@IBAction private func restoreAppearanceDefaultsButtonTouchUpInside(_ sender: Any) {
		
		self.currentSettings?.appearance = Settings.default.appearance
		self.updateWithCurrentSettings()
	}
}

// MARK: - SeguePresenter
extension SettingsTableViewController: SeguePresenter {}

// MARK: - DestinationViewControllerDelegate
extension SettingsTableViewController: DestinationViewControllerDelegate {
	
	internal func destinationViewController(_ controller: DestinationViewController, didFinishWith destination: Destination) {
		
		if let nonnullSelectedDestination = self.selectedDestination {
			
			if let index = self.currentSettings?.dataSource.destinations.firstIndex(of: nonnullSelectedDestination) {
				
				self.currentSettings?.dataSource.destinations.remove(at: index)
				self.currentSettings?.dataSource.destinations.insert(destination, at: index)
			}
			else {
				
				self.currentSettings?.dataSource.destinations.append(destination)
			}
		}
		else {
			
			self.currentSettings?.dataSource.destinations.append(destination)
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
            
            if let index = self.currentSettings?.dataSource.taxes.firstIndex(of: nonnullSelectedTax) {
                
                self.currentSettings?.dataSource.taxes.remove(at: index)
                self.currentSettings?.dataSource.taxes.insert(tax, at: index)
            }
            else {
                
                self.currentSettings?.dataSource.taxes.append(tax)
            }
        }
        else {
            
            self.currentSettings?.dataSource.taxes.append(tax)
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
            
            if let index = self.currentSettings?.dataSource.shippingList.firstIndex(of: nonnullSelectedShipping) {
                
                self.currentSettings?.dataSource.shippingList.remove(at: index)
                self.currentSettings?.dataSource.shippingList.insert(shipping, at: index)
            }
            else {
                
                self.currentSettings?.dataSource.shippingList.append(shipping)
            }
        }
        else {
            
            self.currentSettings?.dataSource.shippingList.append(shipping)
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
				
				self.currentSettings?.global.sdkLanguage = language
			}
			
        case Constants.sdkModeCellReuseIdentifier:
            
            if let sdkMode = value as? SDKMode {
                
                self.currentSettings?.dataSource.sdkMode = sdkMode
                
                if self.currentSettings?.dataSource.customer?.environment != sdkMode {
                    
                    self.currentSettings?.dataSource.customer = nil
                }
            }
			
		case Constants.appearanceModeCellReuseIdentifier:
			
			if let appearanceMode = value as? SDKAppearanceMode {
				
				self.currentSettings?.appearance.appearanceMode = appearanceMode
			}
            
        case Constants.transactionModeCellReuseIdentifier:
            
            if let transactionMode = value as? TransactionMode {
                
                self.currentSettings?.dataSource.transactionMode = transactionMode
            }
            
        case Constants.currencyCellReuseIdentifier:
            
            if let currency = value as? Currency {
                
                self.currentSettings?.dataSource.currency = currency
            }
			
		case Constants.headerTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.headerTextColor = color
			}
			
		case Constants.headerBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.headerBackgroundColor = color
			}

		case Constants.headerCancelNormalColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.headerCancelNormalTextColor = color
			}

		case Constants.headerCancelHighlightedColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.headerCancelHighlightedTextColor = color
			}

		case Constants.headerFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.appearance.headerFont = font
			}
			
		case Constants.headerCancelFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.appearance.headerCancelFont = font
			}
			
		case Constants.cardInputFontCellReuseIdentifier:
			
			if let cardInputFont = value as? String {
				
				self.currentSettings?.appearance.cardInputFont = cardInputFont
			}
			
		case Constants.cardInputDescriptionFontCellReuseIdentifier:
			
			if let cardInputDescriptionFont = value as? String {
			
				self.currentSettings?.appearance.cardInputDescriptionFont = cardInputDescriptionFont
			}
			
		case Constants.cardInputTextColorCellReuseIdentifier:
			
			if let cardInputTextColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputTextColor = cardInputTextColor
			}
			
		case Constants.cardInputTextColorInvalidCellReuseIdentifier:
			
			if let cardInputInvalidTextColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputInvalidTextColor = cardInputInvalidTextColor
			}
			
		case Constants.cardInputTextColorPlaceholderCellReuseIdentifier:
			
			if let cardInputPlaceholderTextColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputPlaceholderTextColor = cardInputPlaceholderTextColor
			}
			
		case Constants.cardInputDescriptionTextColorCellReuseIdentifier:
			
			if let cardInputDescriptionTextColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputDescriptionTextColor = cardInputDescriptionTextColor
			}
			
		case Constants.cardInputSaveCardSwitchOffTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchOffTintColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputSaveCardSwitchOffTintColor = cardInputSaveCardSwitchOffTintColor
			}
			
		case Constants.cardInputSaveCardSwitchOnTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchOnTintColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputSaveCardSwitchOnTintColor = cardInputSaveCardSwitchOnTintColor
			}
			
		case Constants.cardInputSaveCardSwitchThumbTintColorCellReuseIdentifier:
			
			if let cardInputSaveCardSwitchThumbTintColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputSaveCardSwitchThumbTintColor = cardInputSaveCardSwitchThumbTintColor
			}
			
		case Constants.cardInputScanIconFrameTintColorCellReuseIdentifier:
			
			if let cardInputScanIconFrameTintColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputScanIconFrameTintColor = cardInputScanIconFrameTintColor
			}
			
		case Constants.cardInputScanIconTintColorCellReuseIdentifier:
			
			if let cardInputScanIconTintColor = value as? Color {
				
				self.currentSettings?.appearance.cardInputScanIconTintColor = cardInputScanIconTintColor
			}
			
		case Constants.tapButtonDisabledBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonDisabledBackgroundColor = color
			}
			
		case Constants.tapButtonEnabledBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonEnabledBackgroundColor = color
			}
			
		case Constants.tapButtonHighlightedBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonHighlightedBackgroundColor = color
			}
			
		case Constants.tapButtonFontCellReuseIdentifier:
			
			if let font = value as? String {
				
				self.currentSettings?.appearance.tapButtonFont = font
			}
			
		case Constants.tapButtonDisabledTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonDisabledTextColor = color
			}
			
		case Constants.tapButtonEnabledTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonEnabledTextColor = color
			}
			
		case Constants.tapButtonHighlightedTextColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.tapButtonHighlightedTextColor = color
			}
			
		case Constants.backgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.backgroundColor = color
			}
			
		case Constants.contentBackgroundColorCellReuseIdentifier:
			
			if let color = value as? Color {
				
				self.currentSettings?.appearance.contentBackgroundColor = color
			}
			
		case Constants.backgroundBlurStyleCellReuseIdentifier:
			
			if let style = value as? TapBlurStyle {
			
				self.currentSettings?.appearance.backgroundBlurStyle = style
			}
			
		case Constants.paymentTypeCellReuseIdentifier:
			
			if let paymentType = value as? PaymentType {
				
				self.currentSettings?.dataSource.paymentType = paymentType
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
        
        self.currentSettings?.dataSource.customer = customer
        self.updateWithCurrentSettings()
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController.DestinationsTableViewHandler: UITableViewDataSource {
	
	private var destinations: [Destination] {
		
		return self.settings.dataSource.destinations
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
			
			self.settings.dataSource.destinations.remove(at: cellIndexPath.row)
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
        
        return self.settings.dataSource.taxes
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
            
            self.settings.dataSource.taxes.remove(at: cellIndexPath.row)
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
        
        return self.settings.dataSource.shippingList
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
            
            self.settings.dataSource.shippingList.remove(at: cellIndexPath.row)
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
            
            self.settingsController.tableView.beginUpdates()
            self.settingsController.tableView.endUpdates()
        }
        
        return [deleteAction]
    }
}
