//
//  SaveCardValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	QuartzCore.CATransaction.CATransaction
import class	UIKit.UILabel.UILabel
import class    UIKit.UISwitch.UISwitch

internal final class SaveCardValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var shouldSaveCard: Bool {
        
        return self.saveCardSwitch.isOn
    }
    
    internal override var isValid: Bool {
        
        return true
    }
	
	internal var canSaveCard: Bool = false
	
    // MARK: Methods
    
	internal init(switch: UISwitch, label: UILabel) {
        
        self.saveCardSwitch 	= `switch`
		self.descriptionLabel	= label
		
        super.init(validationType: .saveCard)
        
        self.setupSwitch()
		self.setupLabel()
    }
    
    internal override func update(with inputData: Any?) {
        
        if let data = inputData as? Bool {
            
            self.saveCardSwitch.isOn = data
        }
        else {
            
            self.saveCardSwitch.isOn = false
        }
		
		let style = Theme.current.paymentOptionsCellStyle.card.saveCard
		
		self.descriptionLabel.setTextStyle(style.textStyle)
		self.saveCardSwitch.onTintColor = style.switchOnTintColor
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned let saveCardSwitch: UISwitch
	
	private unowned let descriptionLabel: UILabel
    
    // MARK: Methods
    
    private func setupSwitch() {
        
        self.saveCardSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
		self.saveCardSwitch.onTintColor = Theme.current.paymentOptionsCellStyle.card.saveCard.switchOnTintColor
    }
	
	private func setupLabel() {
		
		self.descriptionLabel.setTextStyle(Theme.current.paymentOptionsCellStyle.card.saveCard.textStyle)
	}
    
	@objc private func switchValueChanged(_ sender: Any) {
		
		let strongSelf = self
		if strongSelf.shouldSaveCard && !strongSelf.canSaveCard {
			
			strongSelf.saveCardSwitch.setOn(false, animated: true)
		}
		
		strongSelf.delegate?.cardValidator(strongSelf, inputDataChanged: strongSelf.shouldSaveCard)
	}
}
