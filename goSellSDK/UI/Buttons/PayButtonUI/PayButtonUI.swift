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
    
    // MARK: Methods
    
    internal override func setup() {
        
        super.setup()
        
        self.updateDisplayedStateAndAmount()
    }
    
    internal func updateDisplayedStateAndAmount() {
        
        guard let currency = self.dataSource?.currency else {
            
            self.setTitle(Constants.genericTitle, enabled: false)
            return
        }
        
        let items = self.dataSource?.items ?? []
        
        let amount = AmountCalculator.totalAmount(of: self.dataSource?.items ?? [], with: self.dataSource?.taxes ?? nil, and: self.dataSource?.shipping ?? nil)
        guard amount > 0.0 && items.count > 0 else {
            
            self.setTitle(Constants.genericTitle, enabled: false)
            return
        }
        
        let amountText = "PAY " + CurrencyFormatter.shared.format(AmountedCurrency(currency, amount, currencySymbol: ""))
        
        self.setTitle(amountText, enabled: true)
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
