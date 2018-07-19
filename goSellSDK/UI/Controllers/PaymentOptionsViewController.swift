//
//  PaymentOptionsViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import struct   UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import let      UIKit.UITableView.UITableViewAutomaticDimension
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

internal class PaymentOptionsViewController: BaseViewController {
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.subscribeNotifications()
    }

    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        self.view.endEditing(true)
        
        if let currencySelectionController = segue.destination as? CurrencySelectionViewController {
            
            PaymentDataManager.shared.prepareCurrencySelectionController(currencySelectionController)
        }
        else if let cardScannerController = segue.destination as? CardScannerViewController {
            
            PaymentDataManager.shared.prepareCardScannerController(cardScannerController)
        }
        else if let addressInputController = segue.destination as? AddressInputViewController {
            
            PaymentDataManager.shared.prepareAddressInputController(addressInputController)
        }
        else if let webPaymentController = segue.destination as? WebPaymentViewController {
            
            PaymentDataManager.shared.prepareWebPaymentController(webPaymentController)
        }
    }
    
    internal override func performAdditionalAnimationsAfterKeyboardLayoutFinished() {
        
        PaymentDataManager.shared.paymentOptionsControllerKeyboardLayoutFinished()
    }
    
    internal func showWebPaymentViewController() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(WebPaymentViewController.className)Segue", sender: self)
        }
    }
    
    deinit {
        
        self.unsubscribeNotifications()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
            
            PaymentDataManager.shared.paymentOptionCellViewModels.forEach { ($0 as? TableViewCellViewModel)?.tableView = self.paymentOptionsTableView }
            self.paymentOptionsTableView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        }
    }
    
    @IBOutlet private weak var tableViewTopOffsetConstraint: NSLayoutConstraint?
    
    // MARK: Methods
    
    private func subscribeNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(paymentOptionsUpdated(_:)), name: .paymentOptionsModelsUpdated, object: nil)
    }
    
    private func unsubscribeNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .paymentOptionsModelsUpdated, object: nil)
    }
    
    @objc private func paymentOptionsUpdated(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.paymentOptionsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - PopupOverlaySupport
extension PaymentOptionsViewController: PopupOverlaySupport {
    
    internal var topOffsetOverlayConstraint: NSLayoutConstraint? {
        
        return self.tableViewTopOffsetConstraint
    }
    
    internal var layoutView: UIView {
        
        return self.view
    }
    
    internal func additionalAnimations(for operation: ViewControllerOperation) -> TypeAlias.ArgumentlessClosure {
    
        return {
            
            let overlapping = operation == .presentation ? self.view.bounds.height : 0.0
            MerchantInformationHeaderViewController.findInHierarchy()?.updateBackgroundOpacityBasedOnScrollContentOverlapping(overlapping)
        }
    }
}
