//
//  AmountedCurrencyTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIImageView.UIImageView
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
    @IBOutlet private weak var checkmarkImageView: UIImageView?
    
    @IBOutlet private var constraintsToDisableWhenSelected: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenSelected: [NSLayoutConstraint]?
}

// MARK: - LoadingWithModelCell
extension AmountedCurrencyTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.currencyNameLabel?.text = self.model?.currencyNameText
        self.amountLabel?.text = self.model?.amountText
        self.checkmarkImageView?.image = self.model?.checkmarkImage
        
        self.updateSelectionState(animated: animated)
    }
    
    private func updateSelectionState(animated: Bool) {
        
        guard
            
            let nonnullModel = self.model,
            let nonnullConstraintsToDisableWhenSelected = self.constraintsToDisableWhenSelected,
            let nonnullConstraintsToEnableWhenSelected = self.constraintsToEnableWhenSelected
            
        else { return }
    
        NSLayoutConstraint.reactivate(inCaseIf: nonnullModel.isSelected,
                                      constraintsToDisableOnSuccess: nonnullConstraintsToDisableWhenSelected,
                                      constraintsToEnableOnSuccess: nonnullConstraintsToEnableWhenSelected,
                                      viewToLayout: self,
                                      animationDuration: animated ? Constants.selectionAnimationDuration : 0.0)
    }
}
