//
//  DestinationViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSIndexPath.IndexPath
import struct	Foundation.NSNotification.Notification
import class	goSellSDK.Currency
import class	goSellSDK.Destination
import class	UIKit.UILabel.UILabel
import class	UIKit.UIStoryboardSegue.UIStoryboardSegue
import class	UIKit.UITableView.UITableView
import class	UIKit.UITextField.UITextField
import class	UIKit.UITextView.UITextView

internal final class DestinationViewController: ModalNavigationTableViewController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var delegate: DestinationViewControllerDelegate?
	
	internal var destination: Destination? {
		
		didSet {
			
			self.updateTitle()
			
			if let nonnullDestination = self.destination {
				
				self.currentDestination = nonnullDestination.copy() as! Destination
			}
		}
	}
	
	internal override var isDoneButtonEnabled: Bool {
		
		return !self.currentDestination.identifier.isEmpty && self.currentDestination.amount > 0.0
	}
	
	// MARK: Methods
	
	internal override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.addInputFieldTextChangeObserver()
		self.updateTitle()
		self.updateWithCurrentDestinationInfo()
	}
	
	internal override func doneButtonClicked() {
		
		self.delegate?.destinationViewController(self, didFinishWith: self.currentDestination)
	}
	
	internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else { return }
		
		if reuseIdentifier == Constants.currencyCellReuseIdentifier {
			
			self.show(CaseSelectionTableViewController.self)
		}
	}
	
	internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		super.prepare(for: segue, sender: sender)
		
		if let caseSelectionController = segue.destination as? CaseSelectionTableViewController {
			
			caseSelectionController.delegate = self
			caseSelectionController.title = "Currency"
			caseSelectionController.allValues = Currency.allCases
			caseSelectionController.preselectedValue = self.currentDestination.currency
		}
	}
	
	deinit {
		
		self.removeInputFieldTextChangeObserver()
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let currencyCellReuseIdentifier: String = "currency_cell"
		
		@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	@IBOutlet private weak var identifierTextField: UITextField?
	@IBOutlet private weak var amountTextField: UITextField?
	@IBOutlet private weak var currencyLabel: UILabel?
	@IBOutlet private weak var descriptionTextView: UITextView?
	@IBOutlet private weak var referenceTextField: UITextField?
	
	private var currentDestination: Destination = Destination(identifier: "", amount: 0.0, currency: Settings.default.dataSource.currency) {
		
		didSet {
			
			self.updateWithCurrentDestinationInfo()
		}
	}
	
	// MARK: Methods
	
	private func updateTitle() {
		
		if self.destination == nil {
			
			self.title = "Add Destination"
		}
		else {
			
			self.title = "Edit Destination"
		}
	}
	
	private func updateCurrentDestinationInfoFromInputFields() {
		
		if let destinationIdentifier = self.identifierTextField?.text, !destinationIdentifier.isEmpty {
			
			self.currentDestination.identifier = destinationIdentifier
		}
		else {
			
			self.currentDestination.identifier = ""
		}
		
		if let amount = self.amountTextField?.text?.tap_decimalValue, amount > 0.0 {
			
			self.currentDestination.amount = amount
		}
		else {
			
			self.currentDestination.amount = 0.0
		}
		
		self.currentDestination.descriptionText = self.descriptionTextView?.text
		
		self.currentDestination.reference = self.referenceTextField?.text
	}
	
	private func updateWithCurrentDestinationInfo() {
		
		self.identifierTextField?.text = self.currentDestination.identifier
		self.amountTextField?.text = "\(self.currentDestination.amount)"
		self.currencyLabel?.text = self.currentDestination.currency.isoCode
		self.descriptionTextView?.text = self.currentDestination.descriptionText
		self.referenceTextField?.text = self.currentDestination.reference
	}
}

// MARK: - InputFieldObserver
extension DestinationViewController: InputFieldObserver {
	
	internal func inputFieldTextChanged(_ notification: Notification) {
		
		self.updateCurrentDestinationInfoFromInputFields()
		self.updateDoneButtonState()
	}
}

// MARK: - CaseSelectionTableViewControllerDelegate
extension DestinationViewController: CaseSelectionTableViewControllerDelegate {
	
	internal func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value) {
		
		if let currency = value as? Currency {
			
			self.currentDestination.currency = currency
			self.updateCurrentDestinationInfoFromInputFields()
		}
	}
}

// MARK: - SeguePresenter
extension DestinationViewController: SeguePresenter {}
