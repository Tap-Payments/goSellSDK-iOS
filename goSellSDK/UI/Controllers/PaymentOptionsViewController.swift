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

	internal override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		self.updateMask()
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
		self.updateMask()
    }
    
    internal func showWebPaymentViewController() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(WebPaymentViewController.className)Segue", sender: self)
        }
    }
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		let glowingInset = Theme.current.paymentOptionsCellStyle.glowStyle.radius
		let topInset	= glowingInset
		let bottomInset = glowingInset + Constants.tableViewBottomGradientHeight
		self.paymentOptionsTableView?.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: bottomInset, right: 0.0)
	}
    
    deinit {
        
        self.unsubscribeNotifications()
		self.tableViewGradientLayer.delegate = nil
    }
    
    // MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let tableViewBottomGradientHeight: CGFloat = 8.0
		
		@available(*, unavailable) private init() {}
	}
	
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
            
            PaymentDataManager.shared.paymentOptionCellViewModels.forEach { ($0 as? TableViewCellViewModel)?.tableView = self.paymentOptionsTableView }
        }
    }
    
    @IBOutlet private weak var tableViewTopOffsetConstraint: NSLayoutConstraint?
	
	private lazy var tableViewGradientLayer: CAGradientLayer = {
		
		let gradient = CAGradientLayer()
		
		gradient.shouldRasterize	= true
		gradient.colors				= [UIColor.black.cgColor, UIColor.clear.cgColor]
		gradient.delegate			= self
		gradient.type				= .axial
		gradient.endPoint			= CGPoint(x: 0.5, y: 1.0)
		
		return gradient
	}()
	
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
	
	private func updateMask() {
		
		let height = self.view.bounds.height
		guard height > Constants.tableViewBottomGradientHeight else { return }
		
		self.tableViewGradientLayer.frame = self.view.bounds
		self.tableViewGradientLayer.startPoint = CGPoint(x: 0.5, y: (height - Constants.tableViewBottomGradientHeight) / height)
	
		if self.view.layer.mask !== self.tableViewGradientLayer {

			self.view.layer.mask = self.tableViewGradientLayer
		}
	}
}

// MARK: - CALayerDelegate
extension PaymentOptionsViewController: CALayerDelegate {
	
	internal func action(for layer: CALayer, forKey event: String) -> CAAction? {
		
		guard layer === self.tableViewGradientLayer else { return nil }
		
		return NSNull()
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
