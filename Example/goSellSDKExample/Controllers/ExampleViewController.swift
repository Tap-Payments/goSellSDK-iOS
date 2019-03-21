//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import class    Dispatch.DispatchQueue
import struct   Foundation.NSDecimal.Decimal
import class    goSellSDK.AmountModificator
import class    goSellSDK.Authorize
import class    goSellSDK.AuthorizeAction
import class	goSellSDK.CardVerification
import class    goSellSDK.Charge
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class	goSellSDK.Destination
import class    goSellSDK.EmailAddress
import class    goSellSDK.goSellSDK
import class    goSellSDK.PayButton
import class    goSellSDK.PaymentItem
import class    goSellSDK.PhoneNumber
import class    goSellSDK.Quantity
import class    goSellSDK.Receipt
import class    goSellSDK.Reference
import enum		goSellSDK.SDKAppearanceMode
import protocol	goSellSDK.SessionAppearance
import protocol goSellSDK.SessionDataSource
import protocol goSellSDK.SessionDelegate
import protocol	goSellSDK.SessionProtocol
import class    goSellSDK.Shipping
import class	goSellSDK.TapBlurStyle
import class    goSellSDK.TapSDKError
import class    goSellSDK.Tax
import class	goSellSDK.Token
import enum     goSellSDK.TransactionMode
import class	UIKit.UIActivityIndicatorView.UIActivityIndicatorView
import class	UIKit.UIBarButtonItem.UIBarButtonItem
import class	UIKit.UIBlurEffect.UIBlurEffect
import class	UIKit.UIColor.UIColor
import class	UIKit.UIControl.UIControl
import class	UIKit.UIFont.UIFont
import struct	UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import class	UIKit.UIVisualEffect.UIVisualEffect
import class	UIKit.UIVisualEffectView.UIVisualEffectView

internal class ExampleViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var paymentItems: [PaymentItem] = Serializer.deserialize()
    
    internal var selectedPaymentItems: [PaymentItem]?
    internal var plainAmount: Decimal?
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "goSell SDK Example"
		self.ignoresKeyboardEventsWhenWindowIsNotKey = true
		
		goSellSDK.language = self.paymentSettings.sdkLanguage.localeIdentifier
        goSellSDK.mode = self.paymentSettings.sdkMode
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.updatePayButtonAmount()
		self.updateSavedCardsButtonVisibility()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let paymentController = (segue.destination as? UINavigationController)?.tap_rootViewController as? PaymentItemViewController {
            
            paymentController.delegate = self
            paymentController.paymentItem = self.selectedPaymentItem
        }
        else if let settingsController = (segue.destination as? UINavigationController)?.tap_rootViewController as? SettingsTableViewController {
            
            settingsController.delegate = self
            settingsController.settings = self.paymentSettings
        }
		else if let savedCardsController = (segue.destination as? UINavigationController)?.tap_rootViewController as? SavedCardsTableViewController {
			
			savedCardsController.customerIdentifier = self.paymentSettings.customer?.customer.identifier
		}
    }
    
    internal func showPaymentItemViewController(with item: PaymentItem? = nil) {
        
        self.selectedPaymentItem = item
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(PaymentItemViewController.tap_className)Segue", sender: self)
        }
    }
    
    internal func updatePayButtonAmount() {
        
        self.payButton?.updateDisplayedState()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var paymentSettings: Settings = Serializer.deserialize() ?? .default {
        
        didSet {
			
			goSellSDK.language = self.paymentSettings.sdkLanguage.localeIdentifier
            goSellSDK.mode = self.paymentSettings.sdkMode
        }
    }
    
    private var tableViewHandler: PaymentItemsTableViewHandler?
	
	@IBOutlet private weak var savedCardsButton: UIBarButtonItem?
	
    @IBOutlet private weak var itemsTableView: UITableView? {
        
        didSet {
            
            self.itemsTableView?.tableFooterView = UIView()
            self.createPaymentItemsTableViewHandler()
        }
    }
	
	@IBOutlet private weak var loadingView: UIView?
	@IBOutlet private weak var loader: UIActivityIndicatorView?
	@IBOutlet private weak var loaderBlurView: UIVisualEffectView?
	
    @IBOutlet private weak var payButton: PayButton?
    
    internal var selectedPaymentItem: PaymentItem?
    
    // MARK: Methods
    
    @IBAction private func addButtonTouchUpInside(_ sender: Any) {
        
        self.showPaymentItemViewController()
    }
	
    private func createPaymentItemsTableViewHandler() {
        
        guard let nonnullTableView = self.itemsTableView else { return }
        
        self.tableViewHandler = PaymentItemsTableViewHandler(itemsProvider: self, tableView: nonnullTableView, callbacksHandler: self)
        self.tableViewHandler?.reloadData()
    }
	
	private func updateSavedCardsButtonVisibility() {
		
		self.savedCardsButton?.isEnabled = self.paymentSettings.customer?.customer.identifier != nil
	}
	
	private func startLoader() {
		
		self.loadingView?.isHidden = false
		self.loaderBlurView?.effect = nil
		self.loader?.startAnimating()
		
		let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseOut]
		let animations: () -> Void = { [weak self] in
			
			
			self?.loaderBlurView?.effect = UIBlurEffect(style: .extraLight)
		}
		
		UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: animations, completion: nil)
	}
	
	private func stopLoader() {
		
		let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseIn]
		let animations: () -> Void = { [weak self] in
			
			self?.loaderBlurView?.effect = nil
		}
		
		UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: animations) { [weak self] _ in
			
			self?.loader?.stopAnimating()
			self?.loadingView?.isHidden = true
		}
	}
}

// MARK: - PaymentItemsProvider
extension ExampleViewController: PaymentItemsProvider {}

// MARK: - PaymentItemsTableViewCallbacksHandler
extension ExampleViewController: PaymentItemsTableViewCallbacksHandler {
    
    internal func removePaymentItem(_ item: PaymentItem) {
        
        if let index = self.paymentItems.index(of: item) {
            
            self.paymentItems.remove(at: index)
            Serializer.serialize(self.paymentItems)
        }
    }
    
    internal func selectionChanged(_ items: [PaymentItem]?, plainAmount: Decimal?) {
        
        self.selectedPaymentItems = items
        self.plainAmount = plainAmount
        
        self.updatePayButtonAmount()
    }
    
    internal func accessoryButtonTappedForCell(with item: PaymentItem) {
    
        self.showPaymentItemViewController(with: item)
    }
}

// MARK: - PaymentItemViewControllerDelegate
extension ExampleViewController: PaymentItemViewControllerDelegate {
    
    internal func paymentItemViewController(_ controller: PaymentItemViewController, didFinishWith item: PaymentItem) {
        
        if let nonnullSelectedItem = self.selectedPaymentItem {
            
            if let index = self.paymentItems.index(of: nonnullSelectedItem) {
                
                if let selectedIndex = self.selectedPaymentItems?.index(of: nonnullSelectedItem) {
                    
                    self.selectedPaymentItems?.remove(at: selectedIndex)
                    self.selectedPaymentItems?.append(item)
                }
                
                self.paymentItems.remove(at: index)
                self.paymentItems.insert(item, at: index)
            }
            else {
                
                self.paymentItems.append(item)
            }
        }
        else {
            
            self.paymentItems.append(item)
        }
        
        Serializer.serialize(self.paymentItems)
        
        self.tableViewHandler?.reloadData()
    }
}

// MARK: - SettingsTableViewControlerDelegate
extension ExampleViewController: SettingsTableViewControlerDelegate {
    
    internal func settingsViewController(_ controller: SettingsTableViewController, didFinishWith settings: Settings) {
        
        self.paymentSettings = settings
        Serializer.serialize(settings)
    }
}

// MARK: - SessionDataSource
extension ExampleViewController: SessionDataSource {
    
    internal var currency: Currency? {
        
        return self.paymentSettings.currency
    }
    
    internal var customer: Customer? {
        
        return self.paymentSettings.customer?.customer
    }
    
    internal var amount: Decimal {
        
        return self.plainAmount ?? 0
    }
    
    internal var items: [PaymentItem]? {

        return self.selectedPaymentItems
    }
	
	internal var destinations: [Destination]? {
		
		return self.paymentSettings.destinations
	}
	
    internal var mode: TransactionMode {
        
        return self.paymentSettings.transactionMode
    }
	
    internal var taxes: [Tax]? {

        return self.paymentSettings.taxes
    }
    
    internal var shipping: [Shipping]? {

        return self.paymentSettings.shippingList
    }
    
    internal var require3DSecure: Bool {
        
        return self.paymentSettings.isThreeDSecure
    }
	
	internal var allowsToSaveSameCardMoreThanOnce: Bool {
		
		return self.paymentSettings.canSaveSameCardMultipleTimes
	}
	
	internal var isSaveCardSwitchOnByDefault: Bool {
		
		return self.paymentSettings.isSaveCardSwitchToggleEnabledByDefault
	}
	
    internal var receiptSettings: Receipt? {
        
        return Receipt(email: true, sms: true)
    }
    
    internal var authorizeAction: AuthorizeAction {
        
        return .capture(after: 8)
    }
}


// MARK: - SessionDelegate
extension ExampleViewController: SessionDelegate {
	
	internal func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        
        // payment succeed, saving the customer for reuse.
        
        if let customerID = charge.customer.identifier {
            
            self.saveCustomer(customerID)
			
			self.updateSavedCardsButtonVisibility()
        }
    }
    
    internal func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
        
        // authorization succeed, saving the customer for reuse.
        
        if let customerID = authorize.customer.identifier {
            
            self.saveCustomer(customerID)
			
			self.updateSavedCardsButtonVisibility()
        }
    }
    
    internal func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
        
        // payment failed, payment screen closed.
    }
	
    internal func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
        
        // authorization failed, payment screen closed.
    }
    
    internal func sessionCancelled(_ session: SessionProtocol) {
        
        // payment cancelled (user manually closed the payment screen).
    }
	
	internal func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
		
		// card successfully saved.
		
		if let customerID = cardVerification.customer.identifier {
			
			self.saveCustomer(customerID)
			
			self.updateSavedCardsButtonVisibility()
		}
	}
	
	internal func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
		
		// card failed to save.
	}
	
	internal func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
		
		// card has successfully tokenized.
	}
	
	internal func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
		
		// card failed to tokenize
	}
	
	internal func sessionIsStarting(_ session: SessionProtocol) {
		
		// session is about to start, but UI is not yet shown.
		
		self.startLoader()
	}
	
	internal func sessionHasStarted(_ session: SessionProtocol) {
		
		// session has started, UI is shown (or showing)
		
		self.stopLoader()
	}
	
	internal func sessionHasFailedToStart(_ session: SessionProtocol) {
		
		// session has failed to start.
		
		self.stopLoader()
	}
	
	// MARK: - Private -
	// MARK: Methods
	
    private func saveCustomer(_ customerID: String) {
        
        if let nonnullCustomer = self.customer {
            
            let envCustomer = SerializationHelper.updateCustomer(nonnullCustomer, with: customerID)
            
            self.paymentSettings.customer = envCustomer
            Serializer.serialize(self.paymentSettings)
        }
    }
}

// MARK: - SessionAppearance
extension ExampleViewController: SessionAppearance {

	internal func appearanceMode(for session: SessionProtocol) -> SDKAppearanceMode {

		return self.paymentSettings.appearanceMode
	}

	internal func sessionShouldShowStatusPopup(_ session: SessionProtocol) -> Bool {

		return self.paymentSettings.showsStatusPopup
	}

	internal func backgroundColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.backgroundColor.asUIColor
	}
	
	internal func contentBackgroundColor(for session: SessionProtocol) -> UIColor {
		
		return self.paymentSettings.contentBackgroundColor.asUIColor
	}

	internal func backgroundBlurEffectStyle(for session: SessionProtocol) -> TapBlurStyle {
		
		return self.paymentSettings.backgroundBlurStyle
	}

	@available(iOS 10.0, *)
	internal func backgroundBlurProgress(for session: SessionProtocol) -> CGFloat {

		return self.paymentSettings.backgroundBlurProgress
	}

	internal func headerFont(for session: SessionProtocol) -> UIFont {

		return UIFont(name: self.paymentSettings.headerFont, size: 17.0)!
	}

	internal func headerTextColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.headerTextColor.asUIColor
	}

	internal func headerBackgroundColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.headerBackgroundColor.asUIColor
	}

	internal func headerCancelButtonFont(for session: SessionProtocol) -> UIFont {

		return UIFont(name: self.paymentSettings.headerCancelFont, size: 12.0)!
	}

	internal func headerCancelButtonTextColor(for state: UIControl.State, session: SessionProtocol) -> UIColor {

		switch state {

		case .normal:

			return self.paymentSettings.headerCancelNormalTextColor.asUIColor

		case .highlighted:

			return self.paymentSettings.headerCancelHighlightedTextColor.asUIColor

		default:

			return self.paymentSettings.headerCancelNormalTextColor.asUIColor
		}
	}

	internal func cardInputFieldsFont(for session: SessionProtocol) -> UIFont {

		return UIFont(name: self.paymentSettings.cardInputFont, size: 15.0)!
	}

	internal func cardInputFieldsTextColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputTextColor.asUIColor
	}

	internal func cardInputFieldsPlaceholderColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputPlaceholderTextColor.asUIColor
	}

	internal func cardInputFieldsInvalidTextColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputInvalidTextColor.asUIColor
	}

	internal func cardInputDescriptionFont(for session: SessionProtocol) -> UIFont {

		return UIFont(name: self.paymentSettings.cardInputDescriptionFont, size: 12.0)!
	}

	internal func cardInputDescriptionTextColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputDescriptionTextColor.asUIColor
	}

	internal func cardInputSaveCardSwitchOffTintColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputSaveCardSwitchOffTintColor.asUIColor
	}

	internal func cardInputSaveCardSwitchOnTintColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputSaveCardSwitchOnTintColor.asUIColor
	}

	internal func cardInputSaveCardSwitchThumbTintColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputSaveCardSwitchThumbTintColor.asUIColor
	}

	internal func cardInputScanIconFrameTintColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputScanIconFrameTintColor.asUIColor
	}

	internal func cardInputScanIconTintColor(for session: SessionProtocol) -> UIColor {

		return self.paymentSettings.cardInputScanIconTintColor?.asUIColor ?? .clear
	}

	internal func tapButtonBackgroundColor(for state: UIControl.State, session: SessionProtocol) -> UIColor? {

		switch state {

		case .disabled:

			return self.paymentSettings.tapButtonDisabledBackgroundColor?.asUIColor

		case .normal:

			return self.paymentSettings.tapButtonEnabledBackgroundColor?.asUIColor

		case .highlighted:

			return self.paymentSettings.tapButtonHighlightedTextColor?.asUIColor

		default:

			return nil
		}
	}

	internal func tapButtonFont(for session: SessionProtocol) -> UIFont {

		return UIFont(name: self.paymentSettings.tapButtonFont, size: 17.0)!
	}

	internal func tapButtonTextColor(for state: UIControl.State, session: SessionProtocol) -> UIColor? {

		switch state {

		case .disabled:

			return self.paymentSettings.tapButtonDisabledTextColor?.asUIColor

		case .normal:

			return self.paymentSettings.tapButtonEnabledTextColor?.asUIColor

		case .highlighted:

			return self.paymentSettings.tapButtonHighlightedTextColor?.asUIColor

		default:

			return nil
		}
	}

	internal func tapButtonCornerRadius(for session: SessionProtocol) -> CGFloat {

		return self.paymentSettings.tapButtonCornerRadius
	}

	internal func isLoaderVisibleOnTapButtton(for session: SessionProtocol) -> Bool {

		return self.paymentSettings.isTapButtonLoaderVisible
	}

	internal func isSecurityIconVisibleOnTapButton(for session: SessionProtocol) -> Bool {

		return self.paymentSettings.isTapButtonSecurityIconVisible
	}

	internal func tapButtonInsets(for session: SessionProtocol) -> UIEdgeInsets {

		return self.paymentSettings.tapButtonEdgeInsets
	}

	internal func tapButtonHeight(for session: SessionProtocol) -> CGFloat {

		return self.paymentSettings.tapButtonHeight
	}
}
