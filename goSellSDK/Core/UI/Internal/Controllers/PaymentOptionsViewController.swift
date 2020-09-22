//
//  PaymentOptionsViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	QuartzCore.CAGradientLayer.CAGradientLayer
import protocol	QuartzCore.CALayer.CAAction
import class	QuartzCore.CALayer.CALayer
import protocol	QuartzCore.CALayer.CALayerDelegate
import var		QuartzCore.CAGradientLayer.kCAGradientLayerAxial
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class	UIKit.UIColor.UIColor
import struct   UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import let      UIKit.UITableView.UITableViewAutomaticDimension
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
internal class PaymentOptionsViewController: BaseViewController {
  
    
    
	
	// MARK: - Internal -
	// MARK: Methods
	
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.subscribeNotifications()
    }

	internal override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		self.updateMask()
	}
	
	internal override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		self.shouldShowMask = true
		self.updateMask()
		self.addTableViewContentSizeObserver()
        self.themeChanged()
	}
	
	internal override func viewDidDisappear(_ animated: Bool) {
		
		self.shouldShowMask = false
		self.updateMask()
		self.tableViewContentSizeObservation = nil
		super.viewDidDisappear(animated)
	}
	
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        self.view.endEditing(true)
        
        if let currencySelectionController = segue.destination as? CurrencySelectionViewController {
			
			Process.shared.currencySelectionHandlerInterface.prepareCurrencySelectionController(currencySelectionController)
        }
        else if let cardScannerController = segue.destination as? CardScannerViewController {
			
			Process.shared.cardScannerHandlerInterface.prepareCardScannerController(cardScannerController)
        }
        else if let addressInputController = segue.destination as? AddressInputViewController {
			
			Process.shared.addressInputHandlerInterface.prepareAddressInputController(addressInputController)
        }
        else if let webPaymentController = segue.destination as? WebPaymentViewController {
			
			Process.shared.webPaymentHandlerInterface.prepareWebPaymentController(webPaymentController)
        }
    }
    
    internal override func performAdditionalAnimationsAfterKeyboardLayoutFinished() {
        
        Process.shared.paymentOptionsControllerKeyboardLayoutFinished()
		self.updateMask()
    }
    
	internal func showWebPaymentViewController(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        DispatchQueue.main.async {
			
			let controller = WebPaymentViewController.instantiate()
			Process.shared.webPaymentHandlerInterface.prepareWebPaymentController(controller)
			
			self.navigationController?.tap_pushViewController(controller, animated: true, completion: completion)
        }
    }
	
	internal override func themeChanged() {
		
		super.themeChanged()
		
		let glowingInset = Theme.current.paymentOptionsCellStyle.glowStyle.radius
		let topInset	= glowingInset
		let bottomInset = glowingInset + Constants.tableViewBottomGradientHeight
		self.paymentOptionsTableView?.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: bottomInset, right: 0.0)
        self.paymentOptionsTableView?.reloadData()
	}
    
    deinit {
        
        self.unsubscribeNotifications()
		self.tableViewContentSizeObservation = nil
    }
    
    // MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let tableViewBottomGradientHeight: CGFloat = 8.0
		
		//@available(*, unavailable) private init() { }
	}
	
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
			
			Process.shared.viewModelsHandlerInterface.paymentOptionCellViewModels.forEach { ($0 as? TableViewCellViewModel)?.tableView = self.paymentOptionsTableView }
        }
    }
    
    @IBOutlet private weak var tableViewTopOffsetConstraint: NSLayoutConstraint?
	
	private var tableViewContentSizeObservation: NSKeyValueObservation?
	
	private var shouldShowMask: Bool = false
	
	private lazy var tableViewGradientLayer: CAGradientLayer = {
		
		let gradient = CAGradientLayer()
		
		gradient.shouldRasterize	= true
		gradient.colors				= [UIColor.black.cgColor, UIColor.clear.cgColor]
		
		#if swift(>=4.2)
		gradient.type				= .axial
		#else
		gradient.type				= kCAGradientLayerAxial
		#endif
		
		gradient.endPoint			= CGPoint(x: 0.5, y: 1.0)
		
		return gradient
	}()
	
    // MARK: Methods
    
    private func subscribeNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(paymentOptionsUpdated(_:)), name: .tap_paymentOptionsModelsUpdated, object: nil)
    }
    
    private func unsubscribeNotifications() {
		
        NotificationCenter.default.removeObserver(self, name: .tap_paymentOptionsModelsUpdated, object: nil)
    }
    
    @objc private func paymentOptionsUpdated(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.paymentOptionsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
	
	private func addTableViewContentSizeObserver() {
		
		guard let nonnullTableView = self.paymentOptionsTableView else { return }
		
		self.tableViewContentSizeObservation = nonnullTableView.observe(\.contentSize, options: .new) { (tableView, change) in
			
			self.preferredContentSize = CGSize(width:	tableView.contentSize.width		+ tableView.contentInset.left	+ tableView.contentInset.right,
											   height:	tableView.contentSize.height	+ tableView.contentInset.top	+ tableView.contentInset.bottom)
		}
	}
	
	private func updateMask() {
		
		let height = self.view.bounds.height
		guard height > Constants.tableViewBottomGradientHeight else { return }
		
		if self.tableViewGradientLayer.frame != self.view.bounds {
			
			self.tableViewGradientLayer.frame = self.view.bounds
		}
		
		let startPoint = CGPoint(x: 0.5, y: (height - Constants.tableViewBottomGradientHeight) / height)
		
		if self.tableViewGradientLayer.startPoint != startPoint {
			
			self.tableViewGradientLayer.startPoint = startPoint
		}
	
		if self.shouldShowMask {
			
			if self.view.layer.mask !== self.tableViewGradientLayer {
				
				self.view.layer.mask = self.tableViewGradientLayer
			}
		}
		else {
			
			self.view.layer.mask = nil
		}
	}
}

// MARK: - PopupOverlaySupport
extension PaymentOptionsViewController: PopupOverlaySupport {
    
    internal var topOffsetOverlayConstraint: NSLayoutConstraint? {
        
        return self.tableViewTopOffsetConstraint
    }
	
	internal var bottomOffsetOverlayConstraint: NSLayoutConstraint? {
		
		return nil
	}
	
	internal var bottomOverlayView: UIView? {
		
		return self.paymentOptionsTableView
	}
    
    internal var layoutView: UIView {
        
        return self.view
    }
    
    internal func additionalAnimations(for operation: ViewControllerOperation) -> TypeAlias.ArgumentlessClosure {
    
        return {
            
            let overlapping = operation == .presentation ? self.view.bounds.height : 0.0
			PaymentContentViewController.tap_findInHierarchy()?.updateHeaderShadowOpacity(with: overlapping)
        }
    }
}
