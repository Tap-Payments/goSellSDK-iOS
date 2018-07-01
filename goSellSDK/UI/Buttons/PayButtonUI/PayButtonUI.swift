//
//  PayButtonUI.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class PayButtonUI: TapButton {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payment data source.
    internal weak var dataSource: PaymentDataSource?
    
    internal override class var nibName: String {
        
        return TapButton.className
    }
    
    internal var amount: AmountedCurrency? {
        
        didSet {
            
            self.updateDisplayedStateAndAmount()
        }
    }
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
        
        self.updateDisplayedStateAndAmount()
    }
    
    internal func updateDisplayedStateAndAmount() {
        
        guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
            
            self.setTitle(Constants.genericTitle, enabled: false)
            return
        }
        
        let amountString = CurrencyFormatter.shared.format(displayedAmount)
        let amountText = "PAY " + amountString
        
        self.setTitle(amountText, enabled: self.isEnabled)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let genericTitle = "PAY"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    private func setTitle(_ title: String, enabled: Bool) {
        
        self.setTitle(title)
        self.isEnabled = enabled
    }
}
