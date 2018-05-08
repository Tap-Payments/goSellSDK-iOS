//
//  AmountedCurrencyTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UILabel.UILabel
import class UIKit.UIView.UIView

internal class AmountedCurrencyTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: AmountedCurrencyTableViewCellModel?
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let selectionAnimationDuration: TimeInterval = 0.25
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var currencyNameLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
    
    @IBOutlet private var constraintsToDisableWhenSelected: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenSelected: [NSLayoutConstraint]?
}

// MARK: - LoadingWithModelCell
extension AmountedCurrencyTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.currencyNameLabel?.text = self.model?.currencyNameText
        self.amountLabel?.text = self.model?.amountText
        
        self.updateSelectionState(animated: animated)
    }
    
    private func updateSelectionState(animated: Bool) {
        
        guard
            
            let nonnullModel = self.model,
            let nonnullConstraintsToDisableWhenSelected = self.constraintsToDisableWhenSelected,
            let nonnullConstraintsToEnableWhenSelected = self.constraintsToEnableWhenSelected
            
        else { return }
        
        var constraintsToDisable = nonnullModel.isSelected ? nonnullConstraintsToDisableWhenSelected : nonnullConstraintsToEnableWhenSelected
        var constraintsToEnable = nonnullModel.isSelected ? nonnullConstraintsToEnableWhenSelected : nonnullConstraintsToDisableWhenSelected
        
        constraintsToDisable = constraintsToDisable.filter { $0.isActive }
        constraintsToEnable = constraintsToEnable.filter { !$0.isActive }
        
        guard constraintsToDisable.count + constraintsToEnable.count > 0 else { return }
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            NSLayoutConstraint.deactivate(constraintsToDisable)
            NSLayoutConstraint.activate(constraintsToEnable)
            
            self.layout()
        }
        
        UIView.animate(withDuration: animated ? Constants.selectionAnimationDuration : 0.0, animations: animations)
    }
}
