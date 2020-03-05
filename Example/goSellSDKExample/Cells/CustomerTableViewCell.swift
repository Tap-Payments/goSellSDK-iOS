//
//  CustomerTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UIView
import class    UIKit.UITraitCollection

internal final class CustomerTableViewCell: SelectableCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func fill(with firstName: String?, middleName: String?, lastName: String?, email: String?, phoneISDNumber: String?, phoneNumber: String?, id: String?) {
        
        self.firstNameLabel?.text       = firstName
        self.middleNameLabel?.text      = middleName
        self.lastNameLabel?.text        = lastName
        self.emailLabel?.text           = email
        self.phoneISDNumberLabel?.text  = phoneISDNumber
        self.phoneNumberLabel?.text     = phoneNumber
        self.idLabel?.text              = id
        
         self.backgroundColor = .white
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
    
    @IBOutlet private weak var firstNameLabel: UILabel?
    @IBOutlet private weak var middleNameLabel: UILabel?
    @IBOutlet private weak var lastNameLabel: UILabel?
    @IBOutlet private weak var emailLabel: UILabel?
    @IBOutlet private weak var phoneISDNumberLabel: UILabel?
    @IBOutlet private weak var phoneNumberLabel: UILabel?
    @IBOutlet private weak var idLabel: UILabel?
}
