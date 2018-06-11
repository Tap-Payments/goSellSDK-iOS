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
    
    internal func fill(with name: String?, surname: String?, email: String?, phone: String?, id: String?) {
        
        self.nameLabel?.text = name
        self.surnameLabel?.text = surname
        self.emailLabel?.text = email
        self.phoneLabel?.text = phone
        self.idLabel?.text = id
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var surnameLabel: UILabel?
    @IBOutlet private weak var emailLabel: UILabel?
    @IBOutlet private weak var phoneLabel: UILabel?
    @IBOutlet private weak var idLabel: UILabel?
    @IBOutlet private weak var checkmarkImageView: UIImageView?
}
