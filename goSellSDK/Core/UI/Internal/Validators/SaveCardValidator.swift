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

internal var canSaveCard: Bool = false {

didSet {

if !self.canSaveCard && self.shouldSaveCard {

self.toggleSwitchOff()
}
}
}

	internal override var errorCode: ErrorCode? {
		
		return nil
	}
	
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
		self.saveCardSwitch.tintColor		= style.switchOffTintColor?.color
		self.saveCardSwitch.onTintColor		= style.switchOnTintColor?.color
		self.saveCardSwitch.thumbTintColor	= style.switchThumbTintColor?.color
    }
	
	internal func toggleSwitchOn() {
		
		guard self.canSaveCard else { return }
		
		self.saveCardSwitch.setOn(true, animated: true)
		self.switchToggleStateChanged()
	}
	
	internal func toggleSwitchOff() {
		
		self.saveCardSwitch.setOn(false, animated: true)
		self.switchToggleStateChanged()
	}
	
    // MARK: - Private -
    // MARK: Properties
    
    private unowned let saveCardSwitch: UISwitch
	
	private unowned let descriptionLabel: UILabel
    
    // MARK: Methods
    
    private func setupSwitch() {
        
        self.saveCardSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
		
		let style = Theme.current.paymentOptionsCellStyle.card.saveCard
		
		self.saveCardSwitch.tintColor		= style.switchOffTintColor?.color
		self.saveCardSwitch.onTintColor		= style.switchOnTintColor?.color
		self.saveCardSwitch.thumbTintColor	= style.switchThumbTintColor?.color
    }
	
	private func setupLabel() {
		
		self.descriptionLabel.setTextStyle(Theme.current.paymentOptionsCellStyle.card.saveCard.textStyle)
	}
    
	@objc private func switchValueChanged(_ sender: Any) {
		
		Process.shared.dataManagerInterface.didToggleSaveCardSwitchToOnAutomatically = true
		
		self.switchToggleStateChanged()
	}
	
	private func switchToggleStateChanged() {
		
		if self.shouldSaveCard && !self.canSaveCard {
			
			CATransaction.setCompletionBlock { [weak self] in
				
				self?.saveCardSwitch.setOn(false, animated: true)
			}
		}
		
		self.delegate?.cardValidator(self, inputDataChanged: self.shouldSaveCard)
	}
}
