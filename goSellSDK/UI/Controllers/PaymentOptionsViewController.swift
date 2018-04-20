//
//  PaymentOptionsViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGRect
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import func UIKit.UIGeometry.UIEdgeInsetsMake
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView
import class UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerTransitioningDelegate

internal class PaymentOptionsViewController: UIViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        var models: [PaymentOptionCellViewModel] = []
//        for option in self.paymentOptions {
//
//            let model = PaymentOptionCellViewModel(icon: nil, title: option)
//            models.append(model)
//        }
//
//        self.paymentOptionsViewModels = models
    }
    
    internal override func viewWillLayoutSubviews() {
        
        self.updateContentSize()
        super.viewWillLayoutSubviews()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let webPaymentController = segue.destination as? WebPaymentViewController {
            
//            webPaymentController.transitioningDelegate = self
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let lastCellCornerRadius: CGFloat = 12.0
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsTableView: UITableView? {
        
        didSet {
            
            self.paymentOptionsTableView?.tableHeaderView = UIView(frame: .zero)
            self.paymentOptionsTableView?.tableFooterView = UIView(frame: .zero)
            self.updateContentSize()
        }
    }
    
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint? {
        
        didSet {
            
            self.updateContentSize()
        }
    }
    
    private var paymentOptions: [String] = [
    
        "KNET",
        "VISA",
        "MASTERCARD"
//        "KNET",
//        "VISA",
//        "MASTERCARD",
//        "KNET",
//        "VISA",
//        "MASTERCARD",
//        "KNET",
//        "VISA",
//        "MASTERCARD",
//        "KNET",
//        "VISA",
//        "MASTERCARD"
    ]
    
//    private var paymentOptionsViewModels: [PaymentOptionCellViewModel] = [] {
//        
//        didSet {
//            
//            self.reloadData()
//        }
//    }
    
    private var selectedCellFrame: CGRect = .zero
    
    // MARK: Methods
    
    private func reloadData() {
        
        self.paymentOptionsTableView?.reloadData()
        self.updateContentSize()
    }
    
    private func updateContentSize() {
        
        self.tableViewHeightConstraint?.constant = self.paymentOptionsTableView?.contentSize.height ?? 0.0
    }
}

extension PaymentOptionsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.numberOfCells
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentOptionTableViewCell.className) as? PaymentOptionTableViewCell else {
            
            fatalError("Failed to load \(PaymentOptionTableViewCell.className) from storyboard.")
        }
        
        let index = indexPath.row
        
        cell.fill(with: self.paymentOptionsViewModels[index])
        
        if index + 1 == self.numberOfCells {
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.5 * cell.bounds.size.width, 0.0, 0.5 * cell.bounds.size.width)
        }
        
        return cell
    }
    
    private var numberOfCells: Int {
        
        return self.paymentOptions.count
    }
}

extension PaymentOptionsViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath), let rootController = self.view.window?.rootViewController else { return }
        
        self.selectedCellFrame = cell.convert(cell.bounds, to: rootController.view)
        
        DispatchQueue.main.async { [weak self] in
            
            self?.performSegue(withIdentifier: "\(WebPaymentViewController.className)Segue", sender: self)
        }
    }
}

//extension PaymentOptionsViewController: UIViewControllerTransitioningDelegate {
//
//    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return ExpandAnimationController(startFrame: self.selectedCellFrame)
//    }
//}
