//
//  CardInputTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import class EditableTextInsetsTextField.EditableTextInsetsTextField
import struct TapAdditionsKit.TypeAlias
import class TapEditableView.TapEditableView
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIButton.UIButton
import class UIKit.UICollectionView.UICollectionView
import class UIKit.UIEvent.UIEvent
import struct UIKit.UIGeometry.UIEdgeInsets
import class UIKit.UIScreen.UIScreen
import class UIKit.UISwitch.UISwitch
import class UIKit.UITableView.UITableView
import var UIKit.UITableView.UITableViewAutomaticDimension
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView

internal class CardInputTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardInputTableViewCellModel?
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isSelected {
            
            return super.hitTest(point, with: event)
        }
        
        self.enableUserInteractionAndUpdateToolbarInAllControls()
        
        self.model?.manuallySelectCellAndCallTableViewDelegate()
        
        return super.hitTest(point, with: event)
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
//        if selected {
//
//            self.enableUserInteractionAndUpdateToolbarInAllControls()
//            self.model?.manuallySelectCellAndCallTableViewDelegate()
//        }
        if !selected {
            
            self.firstResponder?.resignFirstResponder()
            self.controls?.forEach { $0.isUserInteractionEnabled = false }
        }
        
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let cvvFieldInsets = UIEdgeInsets(top: 0.0, left: 26.0, bottom: 0.0, right: 0.0)
        fileprivate static let scanButtonAppearanceAnimationDuration: TimeInterval = 0.25
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconsTableView: UITableView?
    
    @IBOutlet private weak var cardNumberTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var cardScannerButton: UIButton?
    
    @IBOutlet private var constraintsToDisableWhenCardScanningAvailable: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenCardScanningAvailable: [NSLayoutConstraint]?
    
    @IBOutlet private weak var expirationDateTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var expirationDateEditableView: TapEditableView?
    
    @IBOutlet private weak var cvvTextField: EditableTextInsetsTextField? {
        
        didSet {
            
            self.cvvTextField?.textInsets = Constants.cvvFieldInsets
        }
    }
    
    @IBOutlet private weak var nameOnCardTextField: EditableTextInsetsTextField?
    
    @IBOutlet private weak var saveCardSwitch: UISwitch?
    
    @IBOutlet private var controls: [UIView]?
    
    // MARK: Methods
    
    @IBAction private func cardScannerButtonTouchUpInside(_ sender: Any) {
        
        self.firstResponder?.resignFirstResponder()
        self.model?.cellCardScannerButtonClicked()
    }
    
    private func enableUserInteractionAndUpdateToolbarInAllControls() {
        
        self.controls?.forEach { $0.isUserInteractionEnabled = true }
        self.controls?.forEach { $0.updateToolbarButtonsState() }
    }
    
    private func updateCardScannerButtonVisibility(animated: Bool) {
        
        guard
            
            let nonnullModel = self.model,
            let nonnullConstraintsToDeactivateIfScanningEnabled = self.constraintsToDisableWhenCardScanningAvailable,
            let nonnullConstraintsToActivateIfScanningEnabled = self.constraintsToEnableWhenCardScanningAvailable
        
        else { return }
        
        let scanButtonAlphaAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.cardScannerButton?.alpha = nonnullModel.scanButtonVisible ? 1.0 : 0.0
        }
        
        NSLayoutConstraint.reactivate(inCaseIf: nonnullModel.scanButtonVisible,
                                      constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfScanningEnabled,
                                      constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfScanningEnabled,
                                      viewToLayout: self,
                                      animationDuration: animated ? Constants.scanButtonAppearanceAnimationDuration : 0.0,
                                      additionalAnimations: scanButtonAlphaAnimation)
    }
}

// MARK: - LoadingWithModelCell
extension CardInputTableViewCell: LoadingWithModelCell {

    internal func updateContent(animated: Bool) {

        self.updateCollectionViewContent(animated)
        
        self.updateCardScannerButtonVisibility(animated: animated)
        self.setGlowing(self.model?.isSelected ?? false)
    }

    private func updateCollectionViewContent(_ animated: Bool) {

        if animated {

            self.iconsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {

            self.iconsTableView?.reloadData()
        }
    }
}

// MARK: - BindingWithModelCell
extension CardInputTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        self.iconsTableView?.dataSource = self.model?.tableViewHandler
        self.iconsTableView?.delegate = self.model?.tableViewHandler
        
        if let cardNumberField = self.cardNumberTextField {
            
            self.model?.bind(cardNumberField, for: .cardNumber)
        }
        
        if let expirationDateField = self.expirationDateTextField {
            
            self.model?.bind(expirationDateField, editableView: self.expirationDateEditableView, for: .expirationDate)
        }
        
        if let cvvField = self.cvvTextField {
            
            self.model?.bind(cvvField, for: .cvv)
        }
        
        if let nameField = self.nameOnCardTextField {
            
            self.model?.bind(nameField, for: .nameOnCard)
        }
    }
}

// MARK: - GlowingCell
extension CardInputTableViewCell: GlowingCell {
    
    internal var glowingView: UIView { return self }
}
