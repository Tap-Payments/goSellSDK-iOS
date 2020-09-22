//
//  AmountedCurrencyTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.NSLayoutConstraint.NSLayoutConstraint
import class	UIKit.UIImageView.UIImageView
import class	UIKit.UILabel.UILabel
import class	UIKit.UIView.UIView

internal class AmountedCurrencyTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: AmountedCurrencyTableViewCellModel?
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let selectionAnimationDuration: TimeInterval = 0.25
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var currencyNameLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
	@IBOutlet private weak var separatorView: UIView?
    
    @IBOutlet private var constraintsToDisableWhenSelected: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenSelected: [NSLayoutConstraint]?
}

// MARK: - LoadingWithModelCell
extension AmountedCurrencyTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.currencyNameLabel?.text	= self.model?.currencyNameText
        self.amountLabel?.text 			= self.model?.amountText
		
		let cellStyle = Theme.current.caseSelectionCellStyle
		
		self.currencyNameLabel?.setTextStyle(cellStyle.title)
		self.amountLabel?.setTextStyle(cellStyle.value)
		
		self.separatorView?.backgroundColor = cellStyle.separator[Process.shared.appearance].color
		
        self.updateSelectionState(animated: animated)
    }
    
    private func updateSelectionState(animated: Bool) {
        
        guard
            
            let nonnullModel = self.model,
            let nonnullConstraintsToDisableWhenSelected = self.constraintsToDisableWhenSelected,
            let nonnullConstraintsToEnableWhenSelected = self.constraintsToEnableWhenSelected
            
        else { return }
    
		NSLayoutConstraint.tap_reactivate(inCaseIf:							nonnullModel.isSelected,
										  constraintsToDisableOnSuccess:	nonnullConstraintsToDisableWhenSelected,
										  constraintsToEnableOnSuccess:		nonnullConstraintsToEnableWhenSelected,
										  viewToLayout:						self,
										  animationDuration:				animated ? Constants.selectionAnimationDuration : 0.0)
	}
}
