//
//  CustomerTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal class CustomerTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        self.checkmarkImageView?.isHidden = !selected
    }
    
    internal func fill(with firstName: String?, middleName: String?, lastName: String?, email: String?, phoneISDNumber: String?, phoneNumber: String?, id: String?) {
        
        self.firstNameLabel?.text       = firstName
        self.middleNameLabel?.text      = middleName
        self.lastNameLabel?.text        = lastName
        self.emailLabel?.text           = email
        self.phoneISDNumberLabel?.text  = phoneISDNumber
        self.phoneNumberLabel?.text     = phoneNumber
        self.idLabel?.text = id
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
    @IBOutlet private weak var checkmarkImageView: UIImageView?
}
