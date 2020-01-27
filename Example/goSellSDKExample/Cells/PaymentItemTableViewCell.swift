//
//  PaymentItemTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UILabel.UILabel
import class    UIKit.UIView
import class    UIKit.UITraitCollection

internal final class PaymentItemTableViewCell: SelectableCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setTitle(_ title: String, quantityValue: String, quantityMeasurement: String, price: String, amount: String, discount: String, taxes: String, total: String) {
        
        self.titleTextLabel?.text = title
        self.quantityValueLabel?.text = quantityValue
        self.quantityMeasurementLabel?.text = quantityMeasurement
        self.priceLabel?.text = price
        self.amountLabel?.text = amount
        self.discountLabel?.text = discount
        self.taxesLabel?.text = taxes
        self.totalAmountLabel?.text = total
        self.backgroundColor = .clear

        if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark
            {
                self.backgroundColor = .black
            }
        }
        
        listSubviewsOfView(view:self)
    }
    
    
    
     func listSubviewsOfView(view:UIView){

        var darkMode = false
        if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark
            {
                 darkMode = true
            }
        }
        print(darkMode)
        // Get the subviews of the view
        let subviews = view.subviews

        // Return if there are no subviews
        if subviews.count == 0 {
            return
        }

        for subview : AnyObject in subviews{
            if let labelView:UILabel = subview as? UILabel
            {
                labelView.textColor = darkMode ? .white : .black
            }else if let viewView:UIView = subview as? UIView
            {
                // List the subviews of subview
                listSubviewsOfView(view: viewView)
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextLabel: UILabel?
    @IBOutlet private weak var quantityValueLabel: UILabel?
    @IBOutlet private weak var quantityMeasurementLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var discountLabel: UILabel?
    @IBOutlet private weak var taxesLabel: UILabel?
    @IBOutlet private weak var totalAmountLabel: UILabel?
}
