//
//  SaveCardValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

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
    
    // MARK: Methods
    
    internal init(switch: UISwitch) {
        
        self.saveCardSwitch = `switch`
        super.init(validationType: .saveCard)
        
        self.setupSwitch()
    }
    
    internal override func update(with inputData: Any?) {
        
        if let data = inputData as? Bool {
            
            self.saveCardSwitch.isOn = data
        }
        else {
            
            self.saveCardSwitch.isOn = false
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned let saveCardSwitch: UISwitch
    
    // MARK: Methods
    
    private func setupSwitch() {
        
        self.saveCardSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchValueChanged(_ sender: Any) {
        
        self.delegate?.cardValidator(self, inputDataChanged: self.shouldSaveCard)
    }
}
